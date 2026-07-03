package com.mkalymlam.controller;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mkalymlam.entity.FichePaie;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.service.FichePaieService;

@Controller
@RequestMapping("/fiches-paie")
public class FichePaieController {

    private final FichePaieService fichePaieService;
    private static final int PDF_LINES_PER_PAGE = 34;

    public FichePaieController(FichePaieService fichePaieService) {
        this.fichePaieService = fichePaieService;
    }

    @GetMapping
    public String list(Model model,
                       @RequestParam(required = false) Long idUtilisateur,
                       @RequestParam(required = false) String moisAnnee) {
        model.addAttribute("fichesPaie", fichePaieService.findFiltered(idUtilisateur, moisAnnee));
        model.addAttribute("selectedUtilisateur", idUtilisateur);
        model.addAttribute("selectedMoisAnnee", moisAnnee);
        return "fichePaie/list";
    }

    @GetMapping("/export/csv")
    public ResponseEntity<byte[]> exportCsv(@RequestParam(required = false) Long idUtilisateur,
                                            @RequestParam(required = false) String moisAnnee) {
        List<FichePaie> fichesPaie = fichePaieService.findFiltered(idUtilisateur, moisAnnee);
        byte[] content = buildCsv(fichesPaie).getBytes(StandardCharsets.UTF_8);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"fiches-paie.csv\"")
                .contentType(MediaType.parseMediaType("text/csv; charset=UTF-8"))
                .body(content);
    }

    @GetMapping("/export/pdf")
    public ResponseEntity<byte[]> exportPdf(@RequestParam(required = false) Long idUtilisateur,
                                            @RequestParam(required = false) String moisAnnee) {
        List<FichePaie> fichesPaie = fichePaieService.findFiltered(idUtilisateur, moisAnnee);
        byte[] content = buildPdf(fichesPaie, moisAnnee);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"fiches-paie.pdf\"")
                .contentType(MediaType.APPLICATION_PDF)
                .body(content);
    }

    @GetMapping("/new")
    public String newForm(Model model) {
        model.addAttribute("fichePaie", new FichePaie());
        model.addAttribute("utilisateurs", fichePaieService.findEmployes());
        return "fichePaie/form";
    }

    @GetMapping("/exists")
    @ResponseBody
    public Map<String, Object> exists(@RequestParam Long idUtilisateur,
                                      @RequestParam String moisAnnee) {
        Map<String, Object> response = new HashMap<>();
        response.put("exists", fichePaieService.findExisting(idUtilisateur, moisAnnee).isPresent());
        return response;
    }

    @PostMapping("/generate")
    public String generate(@RequestParam(required = false) Long idUtilisateur,
                           @RequestParam String moisAnnee,
                           RedirectAttributes redirectAttributes) {
        if (idUtilisateur == null) {
            List<FichePaie> fichesPaie = fichePaieService.genererTous(moisAnnee);
            redirectAttributes.addFlashAttribute("successMessage",
                    fichesPaie.size() + " fiche(s) de paie generee(s) ou regeneree(s) pour le mois " + moisAnnee);
            return "redirect:/fiches-paie?moisAnnee=" + moisAnnee;
        }

        FichePaie fichePaie = fichePaieService.generer(idUtilisateur, moisAnnee);
        redirectAttributes.addFlashAttribute("successMessage",
                "Fiche de paie generee pour "
                        + fichePaie.getUtilisateur().getNom()
                        + " "
                        + fichePaie.getUtilisateur().getPrenom());
        return "redirect:/fiches-paie";
    }

    @ModelAttribute("employes")
    public List<Utilisateur> employes() {
        return fichePaieService.findEmployes();
    }

    private String buildCsv(List<FichePaie> fichesPaie) {
        StringBuilder csv = new StringBuilder();
        csv.append('\uFEFF');
        csv.append("ID,Employe,Mois,Brut,Net verse,Date paiement\n");

        for (FichePaie fiche : fichesPaie) {
            csv.append(csvValue(fiche.getIdFiche()))
                    .append(',')
                    .append(csvValue(nomEmploye(fiche)))
                    .append(',')
                    .append(csvValue(fiche.getMoisAnnee()))
                    .append(',')
                    .append(csvValue(fiche.getMontantFixeBrut()))
                    .append(',')
                    .append(csvValue(fiche.getMontantNetVerse()))
                    .append(',')
                    .append(csvValue(fiche.getDatePaiement()))
                    .append('\n');
        }

        return csv.toString();
    }

    private String csvValue(Object value) {
        String text = value == null ? "" : value.toString();
        return "\"" + text.replace("\"", "\"\"") + "\"";
    }

    private byte[] buildPdf(List<FichePaie> fichesPaie, String moisAnnee) {
        List<String> lines = new ArrayList<>();
        lines.add("Liste des fiches de paie" + (moisAnnee == null || moisAnnee.isBlank() ? "" : " - " + moisAnnee));
        lines.add("");
        lines.add("ID | Employe | Mois | Brut | Net verse | Date paiement");
        lines.add("------------------------------------------------------------");

        for (FichePaie fiche : fichesPaie) {
            lines.add(safePdfText(fiche.getIdFiche()) + " | "
                    + safePdfText(nomEmploye(fiche)) + " | "
                    + safePdfText(fiche.getMoisAnnee()) + " | "
                    + safePdfText(fiche.getMontantFixeBrut()) + " | "
                    + safePdfText(fiche.getMontantNetVerse()) + " | "
                    + safePdfText(fiche.getDatePaiement()));
        }

        if (fichesPaie.isEmpty()) {
            lines.add("Aucune fiche de paie trouvee.");
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

    private String nomEmploye(FichePaie fiche) {
        if (fiche.getUtilisateur() == null) {
            return "";
        }
        return fiche.getUtilisateur().getNom() + " " + fiche.getUtilisateur().getPrenom();
    }
}
