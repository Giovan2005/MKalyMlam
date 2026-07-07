package com.mkalymlam.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import com.mkalymlam.entity.StatutSession;
import com.mkalymlam.entity.Truck;
import com.mkalymlam.repository.SessionTruckRepository;
import com.mkalymlam.repository.StatutDisponibiliteRepository;
import com.mkalymlam.repository.StatutSessionRepository;
import com.mkalymlam.service.TruckService;

@Controller
@RequestMapping("/truck")
public class TruckController {

    private final TruckService truckService;
    private final SessionTruckRepository sessionTruckRepository;
    private final StatutSessionRepository statutSessionRepository;
    private final StatutDisponibiliteRepository statutDisponibiliteRepository;

    public TruckController(TruckService truckService,
                           SessionTruckRepository sessionTruckRepository,
                           StatutSessionRepository statutSessionRepository,
                           StatutDisponibiliteRepository statutDisponibiliteRepository) {
        this.truckService = truckService;
        this.sessionTruckRepository = sessionTruckRepository;
        this.statutSessionRepository = statutSessionRepository;
        this.statutDisponibiliteRepository = statutDisponibiliteRepository;
    }

    @PostMapping("/save")
    @ResponseBody
    public Truck save(@RequestParam String immatriculation,
                      @RequestParam(required = false) String statut) {
        return truckService.save(immatriculation, statut);
    }

    @PostMapping("/update")
    @ResponseBody
    public Truck update(@RequestParam Long id,
                        @RequestParam(required = false) String immatriculation,
                        @RequestParam(required = false) String statut) {
        return truckService.update(id, immatriculation, statut);
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam Long id) {
        truckService.delete(id);
        return "OK";
    }

    @GetMapping("/find")
    @ResponseBody
    public Truck find(@RequestParam Long id) {
        return truckService.find(id);
    }

    @GetMapping("/findAll")
    @ResponseBody
    public List<Truck> findAll() {
        return truckService.findAll();
    }

    @GetMapping("/gestion_truck")
    public String disponibles(Model model) {
        List<Truck> trucks = truckService.findAll();
        StatutSession statutOuverte = statutSessionRepository.findByLibelle("OUVERTE");

        Map<Long, String> truckStatutDisplay = new HashMap<>();
        for (Truck truck : trucks) {
            boolean enSession = statutOuverte != null
                    && sessionTruckRepository.existsByTruckAndStatutSession(truck, statutOuverte);
            truckStatutDisplay.put(truck.getId(), truckService.getStatutDisplay(truck, enSession));
        }

        model.addAttribute("trucks", trucks);
        model.addAttribute("truckStatutDisplay", truckStatutDisplay);
        model.addAttribute("statuts", statutDisponibiliteRepository.findAll());
        return "truck/gestion_truck";
    }
}
