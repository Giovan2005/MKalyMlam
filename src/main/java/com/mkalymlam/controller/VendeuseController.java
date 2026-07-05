package com.mkalymlam.controller;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("vente")
public class VendeuseController {

    private static final int PDF_LINES_PER_PAGE = 34;
    private static final List<FactureStatique> FACTURES = List.of(
            new FactureStatique(1, 101, "FAC-2026-001", "2026-07-03 09:15", "Especes", "1 200 Ar", "24 000 Ar"),
            new FactureStatique(2, 102, "FAC-2026-002", "2026-07-03 10:40", "Mobile Money", "2 500 Ar", "50 000 Ar"),
            new FactureStatique(3, 103, "FAC-2026-003", "2026-07-03 11:25", "Carte", "1 800 Ar", "36 000 Ar"),
            new FactureStatique(4, 104, "FAC-2026-004", "2026-07-03 13:10", "Especes", "900 Ar", "18 000 Ar")
    );

    @GetMapping("/vendeuse")
    public String vendeuse() {
        return "vente/vendeuse";
    }

    @GetMapping("/factures/export/csv")
    public ResponseEntity<byte[]> exportFacturesCsv() {
        byte[] content = buildCsv().getBytes(StandardCharsets.UTF_8);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"factures.csv\"")
                .contentType(MediaType.parseMediaType("text/csv; charset=UTF-8"))
                .body(content);
    }

    @GetMapping("/factures/export/pdf")
    public ResponseEntity<byte[]> exportFacturesPdf() {
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"factures.pdf\"")
                .contentType(MediaType.APPLICATION_PDF)
                .body(buildPdf());
    }

    // @GetMapping("/")
    // public String vendeuse() {
    //     return "vente/vendeuse";
    // }

    private String buildCsv() {
        StringBuilder csv = new StringBuilder();
        csv.append('\uFEFF');
        csv.append("ID Facture,ID Commande,Reference,Date facturation,Mode paiement,Taxes brut,Montant total\n");

        for (FactureStatique facture : FACTURES) {
            csv.append(csvValue(facture.idFacture()))
                    .append(',')
                    .append(csvValue(facture.idCommande()))
                    .append(',')
                    .append(csvValue(facture.reference()))
                    .append(',')
                    .append(csvValue(facture.dateFacturation()))
                    .append(',')
                    .append(csvValue(facture.modePaiement()))
                    .append(',')
                    .append(csvValue(facture.detailsTaxesBrut()))
                    .append(',')
                    .append(csvValue(facture.montantTotal()))
                    .append('\n');
        }

        return csv.toString();
    }

    private String csvValue(Object value) {
        String text = value == null ? "" : value.toString();
        return "\"" + text.replace("\"", "\"\"") + "\"";
    }

    private byte[] buildPdf() {
        List<String> lines = new ArrayList<>();
        lines.add("Liste des factures");
        lines.add("");
        lines.add("ID | Commande | Reference | Date | Paiement | Taxes | Total");
        lines.add("------------------------------------------------------------");

        for (FactureStatique facture : FACTURES) {
            lines.add(safePdfText(facture.idFacture()) + " | "
                    + safePdfText(facture.idCommande()) + " | "
                    + safePdfText(facture.reference()) + " | "
                    + safePdfText(facture.dateFacturation()) + " | "
                    + safePdfText(facture.modePaiement()) + " | "
                    + safePdfText(facture.detailsTaxesBrut()) + " | "
                    + safePdfText(facture.montantTotal()));
        }

        return writeSimplePdf(lines);
    }

    private byte[] writeSimplePdf(List<String> lines) {
        int pageCount = Math.max(1, (int) Math.ceil(lines.size() / (double) PDF_LINES_PER_PAGE));
        int fontObjectNumber = 3 + pageCount * 2;
        List<String> objects = new ArrayList<>();

        objects.add("<< /Type /Catalog /Pages 2 0 R >>");

        StringBuilder kids = new StringBuilder();
        for (int page = 0; page < pageCount; page++) {
            kids.append(3 + page * 2).append(" 0 R ");
        }
        objects.add("<< /Type /Pages /Kids [" + kids + "] /Count " + pageCount + " >>");

        for (int page = 0; page < pageCount; page++) {
            int pageObjectNumber = 3 + page * 2;
            int contentObjectNumber = pageObjectNumber + 1;
            objects.add("<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] "
                    + "/Resources << /Font << /F1 " + fontObjectNumber + " 0 R >> >> "
                    + "/Contents " + contentObjectNumber + " 0 R >>");
            String stream = buildPdfPageStream(lines, page);
            objects.add("<< /Length " + stream.getBytes(StandardCharsets.ISO_8859_1).length + " >>\nstream\n"
                    + stream + "endstream");
        }

        objects.add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>");

        ByteArrayOutputStream pdf = new ByteArrayOutputStream();
        writePdfPart(pdf, "%PDF-1.4\n");
        List<Integer> offsets = new ArrayList<>();

        for (int index = 0; index < objects.size(); index++) {
            offsets.add(pdf.size());
            writePdfPart(pdf, (index + 1) + " 0 obj\n" + objects.get(index) + "\nendobj\n");
        }

        int xrefOffset = pdf.size();
        writePdfPart(pdf, "xref\n0 " + (objects.size() + 1) + "\n");
        writePdfPart(pdf, "0000000000 65535 f \n");
        for (Integer offset : offsets) {
            writePdfPart(pdf, String.format("%010d 00000 n \n", offset));
        }
        writePdfPart(pdf, "trailer\n<< /Size " + (objects.size() + 1) + " /Root 1 0 R >>\n");
        writePdfPart(pdf, "startxref\n" + xrefOffset + "\n%%EOF");

        return pdf.toByteArray();
    }

    private String buildPdfPageStream(List<String> lines, int page) {
        int start = page * PDF_LINES_PER_PAGE;
        int end = Math.min(start + PDF_LINES_PER_PAGE, lines.size());
        StringBuilder stream = new StringBuilder();
        stream.append("BT\n/F1 10 Tf\n14 TL\n50 795 Td\n");

        for (int i = start; i < end; i++) {
            stream.append('(').append(escapePdf(lines.get(i))).append(") Tj\nT*\n");
        }

        stream.append("ET\n");
        return stream.toString();
    }

    private void writePdfPart(ByteArrayOutputStream pdf, String text) {
        byte[] bytes = text.getBytes(StandardCharsets.ISO_8859_1);
        pdf.write(bytes, 0, bytes.length);
    }

    private String safePdfText(Object value) {
        if (value == null) {
            return "";
        }
        String normalized = Normalizer.normalize(value.toString(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "");
        return normalized.replaceAll("[^\\x20-\\x7E]", "");
    }

    private String escapePdf(String value) {
        return value.replace("\\", "\\\\")
                .replace("(", "\\(")
                .replace(")", "\\)");
    }

    private record FactureStatique(int idFacture,
                                   int idCommande,
                                   String reference,
                                   String dateFacturation,
                                   String modePaiement,
                                   String detailsTaxesBrut,
                                   String montantTotal) {
    }
}
