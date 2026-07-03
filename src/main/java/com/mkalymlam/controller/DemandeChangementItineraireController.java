package com.mkalymlam.controller;

import java.time.LocalDateTime;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mkalymlam.entity.DemandeChangementItineraire;
import com.mkalymlam.entity.StatutValidation;
import com.mkalymlam.service.DemandeChangementItineraireService;
import com.mkalymlam.service.ItineraireService;
import com.mkalymlam.service.SessionTruckService;
import com.mkalymlam.service.StatutValidationService;
import com.mkalymlam.service.UtilisateurService;

@Controller
@RequestMapping("/changement-itineraire")
public class DemandeChangementItineraireController {

    private final DemandeChangementItineraireService demandeService;
    private final SessionTruckService sessionTruckService;
    private final UtilisateurService utilisateurService;
    private final ItineraireService itineraireService;
    private final StatutValidationService statutValidationService;

    public DemandeChangementItineraireController(
            DemandeChangementItineraireService demandeService,
            SessionTruckService sessionTruckService,
            UtilisateurService utilisateurService,
            ItineraireService itineraireService,
            StatutValidationService statutValidationService) {

        this.demandeService = demandeService;
        this.sessionTruckService = sessionTruckService;
        this.utilisateurService = utilisateurService;
        this.itineraireService = itineraireService;
        this.statutValidationService = statutValidationService;
    }

    @GetMapping("/liste")
    public String liste(Model model) {

        model.addAttribute(
                "demandes",
                demandeService.findAll());

        return "itineraire/list-changement";
    }

    @GetMapping("/nouveau")
    public String formulaire(Model model) {

        model.addAttribute(
                "demande",
                new DemandeChangementItineraire());

        model.addAttribute(
                "sessions",
                sessionTruckService.findAll());

        model.addAttribute(
                "utilisateurs",
                utilisateurService.findAll());

        model.addAttribute(
                "itineraires",
                itineraireService.findAll());

        model.addAttribute(
                "isEdit",
                false);

        model.addAttribute(
                "actionUrl",
                "/changement-itineraire/demander");

        return "itineraire/demande-changement";
    }

    @PostMapping("/demander")
    public String demander(DemandeChangementItineraire demande) {

        StatutValidation statut =
                statutValidationService.findByLibelle("EN_ATTENTE");

        demande.setDateHeureDemande(LocalDateTime.now());
        demande.setStatutValidation(statut);

        demandeService.demanderChangementItineraire(demande);

        return "redirect:/changement-itineraire/liste";
    }


    @PostMapping("/valider/{id}")
    public String valider(@PathVariable Long id,
                        RedirectAttributes redirectAttributes) {

        demandeService.valider(id);

        redirectAttributes.addFlashAttribute(
                "success",
                "La demande a été validée."
        );

        return "redirect:/changement-itineraire/liste";
    }

    @PostMapping("/refuser/{id}")
public String refuser(@PathVariable Long id,
                      RedirectAttributes redirectAttributes) {

    demandeService.refuser(id);

    redirectAttributes.addFlashAttribute(
            "success",
            "La demande a été refusée."
    );

    return "redirect:/changement-itineraire/liste";
}
}