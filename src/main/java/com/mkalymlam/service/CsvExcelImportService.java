package com.mkalymlam.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

@Service
public class CsvExcelImportService {

    @Autowired
    private TruckService truckService;

    @Autowired
    private ItineraireService itineraireService;

    @Autowired
    private SessionTruckService sessionTruckService;

    @Autowired
    private EquipeSessionService equipeSessionService;

    @Autowired
    private ProduitService produitService;

    @Autowired
    private RecetteBaseService recetteBaseService;

    // ==============================
    // DETECTION DU FORMAT
    // ==============================

    public List<String> importFile(MultipartFile file, String type) throws Exception {
        String fileName = file.getOriginalFilename();
        if (fileName == null) {
            throw new IllegalArgumentException("Nom de fichier invalide");
        }

        if (fileName.toLowerCase().endsWith(".csv")) {
            return importCsv(file, type);
        } else if (fileName.toLowerCase().endsWith(".xlsx") || fileName.toLowerCase().endsWith(".xls")) {
            return importExcel(file, type);
        } else {
            throw new IllegalArgumentException("Format non supporte. Utilisez CSV ou Excel (.xlsx)");
        }
    }

    // ==============================
    // IMPORT CSV
    // ==============================

    public List<String> importCsv(MultipartFile file, String type) throws Exception {
        List<String[]> allData = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream()));
             CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(1).build()) {

            String[] line;
            while ((line = csvReader.readNext()) != null) {
                allData.add(line);
            }
        }

        String[] headers = getCsvHeaders(file);
        return processData(allData, headers, type);
    }

    private String[] getCsvHeaders(MultipartFile file) throws Exception {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream()));
             CSVReader csvReader = new CSVReader(reader)) {
            return csvReader.readNext();
        }
    }

    // ==============================
    // IMPORT EXCEL
    // ==============================

    public List<String> importExcel(MultipartFile file, String type) throws Exception {
        List<String[]> allData = new ArrayList<>();
        String[] headers = null;

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);

            boolean firstRow = true;
            for (Row row : sheet) {
                if (firstRow) {
                    headers = new String[row.getPhysicalNumberOfCells()];
                    for (int i = 0; i < row.getPhysicalNumberOfCells(); i++) {
                        headers[i] = getCellStringValue(row.getCell(i)).trim();
                    }
                    firstRow = false;
                    continue;
                }

                String[] rowData = new String[row.getPhysicalNumberOfCells()];
                for (int i = 0; i < row.getPhysicalNumberOfCells(); i++) {
                    Cell cell = row.getCell(i, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                    rowData[i] = getCellStringValue(cell).trim();
                }
                allData.add(rowData);
            }
        }

        return processData(allData, headers, type);
    }

    private String getCellStringValue(Cell cell) {
        if (cell == null) return "";
        CellType type = cell.getCellType();
        if (type == CellType.FORMULA) {
            type = cell.getCachedFormulaResultType();
        }
        switch (type) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                }
                double val = cell.getNumericCellValue();
                if (val == Math.floor(val) && !Double.isInfinite(val)) {
                    return String.valueOf((long) val);
                }
                return String.valueOf(val);
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
    }

    // ==============================
    // DISPATCH PAR TYPE D'ENTITE
    // ==============================

    private List<String> processData(List<String[]> data, String[] headers, String type) {
        switch (type) {
            case "truck":
                return truckService.importTrucksFromRows(data, headers);
            case "itineraire":
                return itineraireService.importItinerairesFromRows(data, headers);
            case "session":
                return sessionTruckService.importSessionsFromRows(data, headers);
            case "equipe":
                return equipeSessionService.importEquipesFromRows(data, headers);
            case "produit":
                return produitService.importProduitsFromRows(data, headers);
            case "recette":
                return recetteBaseService.importRecettesFromRows(data, headers);
            default:
                throw new IllegalArgumentException("Type inconnu : " + type);
        }
    }
}
