package com.mkalymlam.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

import com.mkalymlam.entity.RecetteBase;
import com.mkalymlam.service.IngredientService;
import com.mkalymlam.service.ProduitService;
import com.mkalymlam.service.RecetteBaseService;
import com.mkalymlam.service.CsvExcelImportService;

@Controller
@RequestMapping("/recetteBase")
public class RecetteBaseController {

    private final RecetteBaseService service;
    private final ProduitService produitService;
    private final IngredientService ingredientService;
    private final CsvExcelImportService csvExcelImportService;

    public RecetteBaseController(
            RecetteBaseService service,
            ProduitService produitService,
            IngredientService ingredientService,
            CsvExcelImportService csvExcelImportService) {

        this.service = service;
        this.produitService = produitService;
        this.ingredientService = ingredientService;
        this.csvExcelImportService = csvExcelImportService;
    }

    // =========================
    // Liste
    // =========================

    @GetMapping
    public String list(Model model) {

        model.addAttribute("recettes", service.findAll());
        model.addAttribute("produits", produitService.findAll());
        model.addAttribute("ingredients", ingredientService.findAll());

        return "recetteBase/list";
    }

    // =========================
    // Formulaire d'ajout
    // =========================

    @GetMapping("/new")
    public String newForm(Model model) {

        model.addAttribute("recette", new RecetteBase());
        model.addAttribute("produits", produitService.findAll());
        model.addAttribute("ingredients", ingredientService.findAll());

        model.addAttribute("isEdit", false);
        model.addAttribute("actionUrl", "/recetteBase");

        return "recetteBase/form";
    }

    // =========================
    // Enregistrement
    // =========================

    @PostMapping
    public String save(@ModelAttribute RecetteBase recette) {

        service.save(recette);

        return "redirect:/recetteBase";
    }

    // =========================
    // Formulaire de modification
    // =========================

    @GetMapping("/{idProduit}/{idIngredient}/edit")
    public String editForm(@PathVariable Long idProduit,
                           @PathVariable Long idIngredient,
                           Model model) {

        RecetteBase recette = service.findById(idProduit, idIngredient);

        model.addAttribute("recette", recette);
        model.addAttribute("produits", produitService.findAll());
        model.addAttribute("ingredients", ingredientService.findAll());

        model.addAttribute("isEdit", true);
        model.addAttribute(
                "actionUrl",
                "/recetteBase/" + idProduit + "/" + idIngredient + "/edit"
        );

        return "recetteBase/form";
    }

    // =========================
    // Mise à jour
    // =========================

    @PostMapping("/{idProduit}/{idIngredient}/edit")
    public String update(@PathVariable Long idProduit,
                         @PathVariable Long idIngredient,
                         @ModelAttribute RecetteBase recette) {

        service.update(idProduit, idIngredient, recette);

        return "redirect:/recetteBase";
    }

    // =========================
    // Suppression
    // =========================

    @PostMapping("/{idProduit}/{idIngredient}/delete")
    public String delete(@PathVariable Long idProduit,
                         @PathVariable Long idIngredient) {

        service.delete(idProduit, idIngredient);

        return "redirect:/recetteBase";
    }

    @GetMapping("/import")
    public String pageImport(Model model) {
        return "recetteBase/import";
    }

    @PostMapping("/import")
    public String importData(@RequestParam("file") MultipartFile file,
                             RedirectAttributes redirectAttributes) {
        try {
            List<String> erreurs = csvExcelImportService.importFile(file, "recette");
            if (erreurs.isEmpty()) {
                redirectAttributes.addFlashAttribute("success",
                    "Recette(s) importee(s) avec succes");
            } else {
                redirectAttributes.addFlashAttribute("warning",
                    "Erreurs : " + String.join("; ", erreurs));
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                "Erreur lors de l'import : " + e.getMessage());
        }
        return "redirect:/recetteBase";
    }

}