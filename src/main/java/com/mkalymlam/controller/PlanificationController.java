package com.mkalymlam.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mkalymlam.entity.Itineraire;
import com.mkalymlam.entity.ItineraireArret;
import com.mkalymlam.entity.PointDeVente;
import com.mkalymlam.service.ItineraireService;
import com.mkalymlam.service.PlanificationService;
import com.mkalymlam.service.PointDeVenteService;

@Controller
@RequestMapping("/planification")
public class PlanificationController {

    private final ItineraireService itineraireService;
    private final PlanificationService planificationService;
    private final PointDeVenteService pointDeVenteService;

    public PlanificationController(ItineraireService itineraireService,
                                   PlanificationService planificationService,
                                   PointDeVenteService pointDeVenteService) {
        this.itineraireService = itineraireService;
        this.planificationService = planificationService;
        this.pointDeVenteService = pointDeVenteService;
    }

    @GetMapping
    public String list(Model model) {
        List<Itineraire> itineraires = itineraireService.findAll();
        model.addAttribute("itineraires", itineraires);
        return "planification/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        Itineraire itineraire = planificationService.getItineraire(id);
        List<ItineraireArret> arrets = planificationService.getArretsByItineraire(id);
        List<PointDeVente> pointsDeVente = pointDeVenteService.findAllActifs();

        model.addAttribute("itineraire", itineraire);
        model.addAttribute("arrets", arrets);
        model.addAttribute("pointsDeVente", pointsDeVente);
        return "planification/detail";
    }

    @GetMapping("/{id}/edit")
    public String edit(@PathVariable Long id, Model model) {
        Itineraire itineraire = planificationService.getItineraire(id);
        List<ItineraireArret> arrets = planificationService.getArretsByItineraire(id);
        List<PointDeVente> pointsDeVente = pointDeVenteService.findAllActifs();

        model.addAttribute("itineraire", itineraire);
        model.addAttribute("arrets", arrets);
        model.addAttribute("pointsDeVente", pointsDeVente);
        model.addAttribute("isEdit", true);
        return "planification/form";
    }

    @PostMapping("/{id}/arrets/save")
    public String saveArrets(@PathVariable Long id,
                             @RequestParam(name = "pointsDeVente", required = false) List<Long> idsPointsDeVente,
                             RedirectAttributes redirectAttributes) {
        try {
            if (idsPointsDeVente != null && !idsPointsDeVente.isEmpty()) {
                planificationService.enregistrerArrets(id, idsPointsDeVente);
            } else {
                planificationService.supprimerTousLesArrets(id);
            }
            redirectAttributes.addFlashAttribute("success", "Arrêts enregistrés avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/planification/" + id;
    }

    @PostMapping("/{id}/arrets/{idArret}/delete")
    public String deleteArret(@PathVariable Long id,
                              @PathVariable Long idArret,
                              RedirectAttributes redirectAttributes) {
        try {
            planificationService.supprimerArret(idArret);
            redirectAttributes.addFlashAttribute("success", "Arrêt supprimé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/planification/" + id;
    }
}
