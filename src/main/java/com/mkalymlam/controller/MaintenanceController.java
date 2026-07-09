package com.mkalymlam.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mkalymlam.entity.HistoriqueMaintenance;
import com.mkalymlam.entity.HistoriqueStatus;
import com.mkalymlam.entity.StatutDisponibilite;
import com.mkalymlam.entity.Truck;
import com.mkalymlam.repository.StatutDisponibiliteRepository;
import com.mkalymlam.service.HistoriqueMaintenanceService;
import com.mkalymlam.service.HistoriqueStatusService;
import com.mkalymlam.service.TruckService;

@Controller
@RequestMapping("/maintenance")
public class MaintenanceController {

    private final HistoriqueMaintenanceService historiqueMaintenanceService;
    private final HistoriqueStatusService historiqueStatusService;
    private final TruckService truckService;
    private final StatutDisponibiliteRepository statutDisponibiliteRepository;

    public MaintenanceController(HistoriqueMaintenanceService historiqueMaintenanceService,
                                  HistoriqueStatusService historiqueStatusService,
                                  TruckService truckService,
                                  StatutDisponibiliteRepository statutDisponibiliteRepository) {
        this.historiqueMaintenanceService = historiqueMaintenanceService;
        this.historiqueStatusService = historiqueStatusService;
        this.truckService = truckService;
        this.statutDisponibiliteRepository = statutDisponibiliteRepository;
    }

    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("maintenances", historiqueMaintenanceService.findAll());
        return "maintenance/list";
    }

    @GetMapping("/new")
    public String newForm(Model model) {
        model.addAttribute("maintenance", new HistoriqueMaintenance());
        model.addAttribute("trucks", truckService.findAll());
        model.addAttribute("isEdit", false);
        model.addAttribute("actionUrl", "/maintenance/save");
        return "maintenance/form";
    }

    @PostMapping("/save")
    public String save(@RequestParam Long truckId,
                       @RequestParam String dateDebut,
                       @RequestParam(required = false) String description) {
        historiqueMaintenanceService.save(truckId, LocalDate.parse(dateDebut), description);
        return "redirect:/maintenance/list";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("maintenance", historiqueMaintenanceService.find(id));
        model.addAttribute("trucks", truckService.findAll());
        model.addAttribute("isEdit", true);
        model.addAttribute("actionUrl", "/maintenance/" + id + "/edit");
        return "maintenance/form";
    }

    @PostMapping("/{id}/edit")
    public String update(@PathVariable Long id,
                         @RequestParam(required = false) Long truckId,
                         @RequestParam(required = false) String dateDebut,
                         @RequestParam(required = false) String dateFin,
                         @RequestParam(required = false) String description) {
        LocalDate debut = dateDebut != null && !dateDebut.isBlank() ? LocalDate.parse(dateDebut) : null;
        LocalDate fin = dateFin != null && !dateFin.isBlank() ? LocalDate.parse(dateFin) : null;
        historiqueMaintenanceService.update(id, truckId, debut, fin, description);
        return "redirect:/maintenance/list";
    }

    @PostMapping("/{id}/cloturer")
    public String cloturer(@PathVariable Long id) {
        historiqueMaintenanceService.cloturer(id);
        return "redirect:/maintenance/list";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        historiqueMaintenanceService.delete(id);
        return "redirect:/maintenance/list";
    }

    @GetMapping("/status")
    public String statusHistory(@RequestParam(required = false) Long truckId,
                                @RequestParam(required = false) Long statutId,
                                Model model) {
        List<HistoriqueStatus> statusList;
        if (truckId != null && statutId != null) {
            Truck truck = truckService.find(truckId);
            StatutDisponibilite statut = statutDisponibiliteRepository.findById(statutId).orElse(null);
            statusList = statut != null
                    ? historiqueStatusService.findByTruckAndStatut(truck, statut)
                    : historiqueStatusService.findByTruck(truck);
        } else if (truckId != null) {
            statusList = historiqueStatusService.findByTruck(truckService.find(truckId));
        } else if (statutId != null) {
            StatutDisponibilite statut = statutDisponibiliteRepository.findById(statutId).orElse(null);
            statusList = statut != null
                    ? historiqueStatusService.findByStatut(statut)
                    : historiqueStatusService.findAll();
        } else {
            statusList = historiqueStatusService.findAll();
        }

        model.addAttribute("statusList", statusList);
        model.addAttribute("trucks", truckService.findAll());
        model.addAttribute("statuts", statutDisponibiliteRepository.findAll());
        model.addAttribute("selectedTruckId", truckId);
        model.addAttribute("selectedStatutId", statutId);
        return "maintenance/status";
    }
}
