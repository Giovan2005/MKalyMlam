package com.mkalymlam.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mkalymlam.entity.Produit;
import com.mkalymlam.service.ProduitService;
import com.mkalymlam.service.CsvExcelImportService;

@Controller
@RequestMapping("/produits")
public class ProduitController {

    private final ProduitService service;
    private final CsvExcelImportService csvExcelImportService;

    public ProduitController(ProduitService service,
                             CsvExcelImportService csvExcelImportService) {
        this.service = service;
        this.csvExcelImportService = csvExcelImportService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("produits", service.findAll());
        return "produit/list";
    }

    @GetMapping("/liste")
    @ResponseBody
    public List<Produit> liste() {
        return service.findAll();
    }

    
    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("produit", new Produit());
        model.addAttribute("isEdit", false);
        model.addAttribute("actionUrl", "/produits");
        return "produit/form";
    }

    @PostMapping
    public String create(
            @RequestParam String nomProduit,
            @RequestParam Double prixBase,
            @RequestParam(required = false)
            Boolean estNouveau) {

        Produit produit = new Produit();

        produit.setNomProduit(nomProduit);
        produit.setPrixBase(prixBase);
        produit.setEstNouveau(
                estNouveau != null ? estNouveau : false);

        produit.setDateCreation(LocalDate.now());

        service.save(produit);

        return "redirect:/produits";
    }

    @GetMapping("/{id}/edit")
    public String editForm(
            @PathVariable Long id,
            Model model) {

        model.addAttribute(
                "produit",
                service.getById(id));

        model.addAttribute("isEdit", true);

        model.addAttribute(
                "actionUrl",
                "/produits/" + id + "/edit");

        return "produit/form";
    }

    @PostMapping("/{id}/edit")
    public String update(
            @PathVariable Long id,
            @RequestParam String nomProduit,
            @RequestParam Double prixBase,
            @RequestParam(required = false)
            Boolean estNouveau) {

        Produit produit =
                service.getById(id);

        produit.setNomProduit(nomProduit);
        produit.setPrixBase(prixBase);
        produit.setEstNouveau(
                estNouveau != null ? estNouveau : false);

        service.save(produit);

        return "redirect:/produits";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {

        service.deleteById(id);

        return "redirect:/produits";
    }

    @GetMapping("/import")
    public String pageImport(Model model) {
        return "produit/import";
    }

    @PostMapping("/import")
    public String importData(@RequestParam("file") MultipartFile file,
                             RedirectAttributes redirectAttributes) {
        try {
            List<String> erreurs = csvExcelImportService.importFile(file, "produit");
            if (erreurs.isEmpty()) {
                redirectAttributes.addFlashAttribute("success",
                    "Produit(s) importe(s) avec succes");
            } else {
                redirectAttributes.addFlashAttribute("warning",
                    "Erreurs : " + String.join("; ", erreurs));
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                "Erreur lors de l'import : " + e.getMessage());
        }
        return "redirect:/produits";
    }
}