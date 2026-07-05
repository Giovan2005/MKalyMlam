package com.mkalymlam.controller;

import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.service.EmployeService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/employes")
public class EmployeController {

    private final EmployeService employeService;

    public EmployeController(EmployeService employeService) {
        this.employeService = employeService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("employes", employeService.findAll());
        model.addAttribute("roleLibelle",
            (java.util.function.IntFunction<String>) id -> employeService.getRoleLibelle(id));
        return "employe/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Utilisateur> opt = employeService.findById(id);
        if (opt.isPresent()) {
            model.addAttribute("employe", opt.get());
            model.addAttribute("roleLibelle", employeService.getRoleLibelle(opt.get().getIdRole()));
            return "employe/detail";
        } else {
            redirectAttributes.addFlashAttribute("error", "Employé introuvable");
            return "redirect:/employes";
        }
    }

    @PostMapping("/{id}/toggle-status")
    public String toggleStatus(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            employeService.toggleStatus(id);
            redirectAttributes.addFlashAttribute("success", "Statut modifié avec succès");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/employes";
    }

    @GetMapping("/export/csv")
    public void exportCSV(HttpServletResponse response) throws IOException {
        List<Utilisateur> employes = employeService.findAll();

        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"employes.csv\"");

        PrintWriter writer = response.getWriter();
        writer.println("ID,Nom,Prénom,Email,Rôle,Salaire,Statut");
        for (Utilisateur u : employes) {
            writer.printf("%d,%s,%s,%s,%s,%.2f,%s%n",
                    u.getIdUtilisateur(),
                    u.getNom(),
                    u.getPrenom() != null ? u.getPrenom() : "",
                    u.getEmail(),
                    employeService.getRoleLibelle(u.getIdRole()),
                    u.getSalaireBaseFixe() != null ? u.getSalaireBaseFixe() : 0.0,
                    u.getStatutActif() ? "Actif" : "Inactif"
            );
        }
        writer.flush();
    }

    // Nouvelle méthode : page imprimable
    @GetMapping("/print")
    public String printPage(Model model) {
        model.addAttribute("employes", employeService.findAll());
        model.addAttribute("roleLibelle",
            (java.util.function.IntFunction<String>) id -> employeService.getRoleLibelle(id));
        return "employe/print";
    }
}