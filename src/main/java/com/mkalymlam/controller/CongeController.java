package com.mkalymlam.controller;

import com.mkalymlam.entity.AbsenceConge;
import com.mkalymlam.service.CongeService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/conges")
public class CongeController {

    private final CongeService congeService;

    public CongeController(CongeService congeService) {
        this.congeService = congeService;
    }

    // Liste des congés
    @GetMapping
    public String list(Model model) {
        List<AbsenceConge> absences = congeService.findAll();
        model.addAttribute("absences", absences);
        model.addAttribute("typeLibelle", (java.util.function.IntFunction<String>) congeService::getTypeCongeLibelle);
        model.addAttribute("statutLibelle", (java.util.function.IntFunction<String>) congeService::getStatutLibelle);
        model.addAttribute("employeService", congeService);
        return "conge/list";
    }

    // Formulaire de demande
    @GetMapping("/demande")
    public String demandeForm(Model model) {
        model.addAttribute("employes", congeService.getAllEmployes());
        return "conge/demande";
    }

    // Traitement de la demande
    @PostMapping("/demande")
    public String demander(@RequestParam Integer idUtilisateur,
                           @RequestParam Integer idTypeConge,
                           @RequestParam LocalDate dateDebut,
                           @RequestParam LocalDate dateFin,
                           @RequestParam(required = false) BigDecimal deduction,
                           @RequestParam(required = false) Integer idRemplacant,
                           RedirectAttributes redirectAttributes) {
        try {
            congeService.demanderConge(idUtilisateur, idTypeConge, dateDebut, dateFin, deduction, idRemplacant);
            redirectAttributes.addFlashAttribute("success", "Demande de congé enregistrée");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/conges";
    }

    // Validation d'un congé
    @PostMapping("/valider/{id}")
    public String valider(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            congeService.valider(id);
            redirectAttributes.addFlashAttribute("success", "Congé validé");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/conges";
    }

    // Refus d'un congé
    @PostMapping("/refuser/{id}")
    public String refuser(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            congeService.refuser(id);
            redirectAttributes.addFlashAttribute("success", "Congé refusé");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/conges";
    }

    // Export CSV
    @GetMapping("/export/csv")
    public void exportCSV(HttpServletResponse response) throws IOException {
        List<AbsenceConge> absences = congeService.findAll();
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"conges.csv\"");
        PrintWriter writer = response.getWriter();
        writer.println("ID,Employé,Type,Début,Fin,Statut,Déduction (Ar),Remplaçant ID");
        for (AbsenceConge a : absences) {
            String employeNom = congeService.getEmployeById(a.getIdUtilisateur())
                    .map(u -> u.getPrenom() + " " + u.getNom()).orElse("?");
            writer.printf("%d,%s,%s,%s,%s,%s,%.2f,%s%n",
                    a.getIdAbsence(),
                    employeNom,
                    congeService.getTypeCongeLibelle(a.getIdTypeConge()),
                    a.getDateDebut(),
                    a.getDateFin(),
                    congeService.getStatutLibelle(a.getIdStatutValidation()),
                    a.getDeductionSalaireAppliquee(),
                    a.getIdRemplacant() != null ? a.getIdRemplacant().toString() : ""
            );
        }
        writer.flush();
    }

    // Page imprimable (export PDF via navigateur)
    @GetMapping("/print")
    public String printPage(Model model) {
        model.addAttribute("absences", congeService.findAll());
        model.addAttribute("typeLibelle", (java.util.function.IntFunction<String>) congeService::getTypeCongeLibelle);
        model.addAttribute("statutLibelle", (java.util.function.IntFunction<String>) congeService::getStatutLibelle);
        model.addAttribute("employeService", congeService);
        return "conge/print";
    }
}