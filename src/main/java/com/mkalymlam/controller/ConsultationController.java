package com.mkalymlam.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mkalymlam.entity.Itineraire;
import com.mkalymlam.entity.ItineraireArret;
import com.mkalymlam.service.ItineraireService;
import com.mkalymlam.service.PlanificationService;
import com.mkalymlam.service.TruckService;

@Controller
@RequestMapping("/consultation")
public class ConsultationController {

    private final ItineraireService itineraireService;
    private final PlanificationService planificationService;
    private final TruckService truckService;

    public ConsultationController(ItineraireService itineraireService,
                                  PlanificationService planificationService,
                                  TruckService truckService) {
        this.itineraireService = itineraireService;
        this.planificationService = planificationService;
        this.truckService = truckService;
    }

    @GetMapping
    public String search(@RequestParam(name = "nomZone", required = false) String nomZone,
                         @RequestParam(name = "jourSemaine", required = false) String jourSemaine,
                         @RequestParam(name = "disponible", required = false) Boolean disponible,
                         Model model) {

        List<Itineraire> itineraires = itineraireService.search(nomZone, jourSemaine, null);

        if (Boolean.TRUE.equals(disponible)) {
            boolean hasTruckDisponible = !truckService.findDisponibles().isEmpty();
            if (!hasTruckDisponible) {
                itineraires = List.of();
            }
        }

        model.addAttribute("itineraires", itineraires);
        model.addAttribute("selectedNomZone", nomZone);
        model.addAttribute("selectedJourSemaine", jourSemaine);
        model.addAttribute("selectedDisponible", disponible);
        return "consultation/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        Itineraire itineraire = planificationService.getItineraire(id);
        List<ItineraireArret> arrets = planificationService.getArretsByItineraire(id);

        model.addAttribute("itineraire", itineraire);
        model.addAttribute("arrets", arrets);
        return "consultation/detail";
    }
}
