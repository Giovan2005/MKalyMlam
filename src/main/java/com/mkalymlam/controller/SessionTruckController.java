package com.mkalymlam.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mkalymlam.entity.EquipeSession;
import com.mkalymlam.entity.Itineraire;
import com.mkalymlam.entity.SessionTruck;
import com.mkalymlam.entity.Truck;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.repository.EquipeSessionRepository;
import com.mkalymlam.repository.ItineraireRepository;
import com.mkalymlam.repository.UtilisateurRepository;
import com.mkalymlam.service.SessionTruckService;
import com.mkalymlam.service.TruckService;

@Controller
@RequestMapping("/session")
public class SessionTruckController {

    private final SessionTruckService sessionTruckService;
    private final TruckService truckService;
    private final ItineraireRepository itineraireRepository;
    private final UtilisateurRepository utilisateurRepository;
    private final EquipeSessionRepository equipeSessionRepository;

    public SessionTruckController(SessionTruckService sessionTruckService,
                                  TruckService truckService,
                                  ItineraireRepository itineraireRepository,
                                  UtilisateurRepository utilisateurRepository,
                                  EquipeSessionRepository equipeSessionRepository) {
        this.sessionTruckService = sessionTruckService;
        this.truckService = truckService;
        this.itineraireRepository = itineraireRepository;
        this.utilisateurRepository = utilisateurRepository;
        this.equipeSessionRepository = equipeSessionRepository;
    }

    @GetMapping("/ouvrir")
    public String formulaireOuvrir(Model model) {
        List<Truck> trucksDisponibles = truckService.findDisponibles();
        List<Itineraire> itineraires = itineraireRepository.findAll();
        List<Utilisateur> chauffeurs = utilisateurRepository.findByRoleLibelle("CHAUFFEUR");

        model.addAttribute("trucks", trucksDisponibles);
        model.addAttribute("itineraires", itineraires);
        model.addAttribute("chauffeurs", chauffeurs);
        return "session/ouvrirSession";
    }

    @PostMapping("/ouvrir")
    public String ouvrir(@RequestParam Long idTruck,
                         @RequestParam Long idItineraire,
                         @RequestParam Long idChauffeur,
                         @RequestParam Double fondDeCaisseOuverture,
                         RedirectAttributes redirectAttributes) {
        try {
            sessionTruckService.ouvrir(idTruck, idItineraire, idChauffeur, fondDeCaisseOuverture);
            redirectAttributes.addFlashAttribute("success", "Session ouverte avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/session/liste";
    }

    @GetMapping("/liste")
    public String listeSessions(Model model) {
        List<SessionTruck> sessions = sessionTruckService.findSessionsDuJour();
        List<String> chauffeurs = new ArrayList<>();

        for (SessionTruck s : sessions) {
            List<EquipeSession> equipe = equipeSessionRepository.findBySessionTruck(s);
            if (!equipe.isEmpty()) {
                Utilisateur u = equipe.get(0).getUtilisateur();
                chauffeurs.add(u.getPrenom() + " " + u.getNom());
            } else {
                chauffeurs.add("");
            }
        }

        model.addAttribute("sessions", sessions);
        model.addAttribute("chauffeurs", chauffeurs);
        return "session/listeSessions";
    }

    @PostMapping("/cloturer")
    public String cloturer(@RequestParam Long idSession,
                           @RequestParam Double fondDeCaisseCloture,
                           RedirectAttributes redirectAttributes) {
        try {
            sessionTruckService.cloturer(idSession, fondDeCaisseCloture);
            redirectAttributes.addFlashAttribute("success", "Session clôturée avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/session/liste";
    }
}
