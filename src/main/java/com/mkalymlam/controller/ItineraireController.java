package com.mkalymlam.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

import com.mkalymlam.entity.Itineraire;
import com.mkalymlam.service.ItineraireService;
import com.mkalymlam.service.CsvExcelImportService;

@Controller
@RequestMapping("/itineraire")
public class ItineraireController {

    private final ItineraireService service;
    private final CsvExcelImportService csvExcelImportService;

    public ItineraireController(ItineraireService service,
                                CsvExcelImportService csvExcelImportService) {
        this.service = service;
        this.csvExcelImportService = csvExcelImportService;
    }

    // ============================
    // Liste des itinéraires
    // ============================

    @GetMapping
    public String list(@RequestParam(name = "nomZone", required = false) String nomZone,
                       @RequestParam(name = "jourSemaine", required = false) String jourSemaine,
                       @RequestParam(name = "lieuExact", required = false) String lieuExact,
                       Model model) {

        List<Itineraire> result = service.search(nomZone, jourSemaine, lieuExact);

        model.addAttribute("itineraires", result);
        model.addAttribute("selectedNomZone", nomZone);
        model.addAttribute("selectedJourSemaine", jourSemaine);
        model.addAttribute("selectedLieuExact", lieuExact);

        return "itineraire/list";
    }

    // ============================
    // Formulaire d'ajout
    // ============================

    @GetMapping("/new")
    public String newForm(Model model) {

        model.addAttribute("itineraire", new Itineraire());
        model.addAttribute("isEdit", false);
        model.addAttribute("actionUrl",
                "/itineraire");

        return "itineraire/form";
    }

    // ============================
    // Enregistrer
    // ============================

    @PostMapping
    public String save(@ModelAttribute Itineraire itineraire) {

        service.save(itineraire);

        return "redirect:/itineraire";
    }

    // ============================
    // Formulaire de modification
    // ============================

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id,
                           Model model) {

        Itineraire itineraire = service.find(id);

        model.addAttribute("itineraire", itineraire);
        model.addAttribute("isEdit", true);
        model.addAttribute("actionUrl",
                "/itineraire/" + id + "/edit");

        return "itineraire/form";
    }

    // ============================
    // Mise à jour
    // ============================

    @PostMapping("/{id}/edit")
    public String update(@PathVariable Long id,
                         @ModelAttribute Itineraire itineraire) {

        itineraire.setId(id);

        service.save(itineraire);

        return "redirect:/itineraire";
    }

    // ============================
    // Suppression
    // ============================

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {

        service.delete(id);

        return "redirect:/itineraire";
    }

    @GetMapping("/import")
    public String pageImport(Model model) {
        return "itineraire/import";
    }

    @PostMapping("/import")
    public String importData(@RequestParam("file") MultipartFile file,
                             RedirectAttributes redirectAttributes) {
        try {
            List<String> erreurs = csvExcelImportService.importFile(file, "itineraire");
            if (erreurs.isEmpty()) {
                redirectAttributes.addFlashAttribute("success",
                    "Itineraire(s) importe(s) avec succes");
            } else {
                redirectAttributes.addFlashAttribute("warning",
                    "Erreurs : " + String.join("; ", erreurs));
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                "Erreur lors de l'import : " + e.getMessage());
        }
        return "redirect:/itineraire";
    }

}