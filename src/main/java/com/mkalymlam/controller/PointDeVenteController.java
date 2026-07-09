package com.mkalymlam.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mkalymlam.entity.PointDeVente;
import com.mkalymlam.service.PointDeVenteService;

@Controller
@RequestMapping("/points-vente")
public class PointDeVenteController {

    private final PointDeVenteService service;

    public PointDeVenteController(PointDeVenteService service) {
        this.service = service;
    }

    @GetMapping
    public String list(Model model) {
        List<PointDeVente> pointsDeVente = service.findAll();
        model.addAttribute("pointsDeVente", pointsDeVente);
        return "pointDeVente/list";
    }

    @GetMapping("/new")
    public String newForm(Model model) {
        model.addAttribute("pointDeVente", new PointDeVente());
        model.addAttribute("isEdit", false);
        model.addAttribute("actionUrl", "/points-vente");
        return "pointDeVente/form";
    }

    @PostMapping
    public String save(@ModelAttribute PointDeVente pointDeVente,
                       RedirectAttributes redirectAttributes) {
        try {
            service.save(pointDeVente);
            redirectAttributes.addFlashAttribute("success", "Point de vente ajouté avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/points-vente";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        PointDeVente pointDeVente = service.find(id);
        model.addAttribute("pointDeVente", pointDeVente);
        model.addAttribute("isEdit", true);
        model.addAttribute("actionUrl", "/points-vente/" + id + "/edit");
        return "pointDeVente/form";
    }

    @PostMapping("/{id}/edit")
    public String update(@PathVariable Long id,
                         @ModelAttribute PointDeVente pointDeVente,
                         RedirectAttributes redirectAttributes) {
        try {
            pointDeVente.setId(id);
            service.update(pointDeVente);
            redirectAttributes.addFlashAttribute("success", "Point de vente modifié avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/points-vente";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id,
                         RedirectAttributes redirectAttributes) {
        try {
            service.delete(id);
            redirectAttributes.addFlashAttribute("success", "Point de vente supprimé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/points-vente";
    }
}
