package com.mkalymlam.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mkalymlam.entity.FichePaie;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.service.FichePaieService;

@Controller
@RequestMapping("/fiches-paie")
public class FichePaieController {

    private final FichePaieService fichePaieService;

    public FichePaieController(FichePaieService fichePaieService) {
        this.fichePaieService = fichePaieService;
    }

    @GetMapping
    public String list(Model model,
                       @RequestParam(required = false) Long idUtilisateur,
                       @RequestParam(required = false) String moisAnnee) {
        model.addAttribute("fichesPaie", fichePaieService.findFiltered(idUtilisateur, moisAnnee));
        model.addAttribute("selectedUtilisateur", idUtilisateur);
        model.addAttribute("selectedMoisAnnee", moisAnnee);
        return "fichePaie/list";
    }

    @GetMapping("/new")
    public String newForm(Model model) {
        model.addAttribute("fichePaie", new FichePaie());
        model.addAttribute("utilisateurs", fichePaieService.findEmployes());
        return "fichePaie/form";
    }

    @GetMapping("/exists")
    @ResponseBody
    public Map<String, Object> exists(@RequestParam Long idUtilisateur,
                                      @RequestParam String moisAnnee) {
        Map<String, Object> response = new HashMap<>();
        response.put("exists", fichePaieService.findExisting(idUtilisateur, moisAnnee).isPresent());
        return response;
    }

    @PostMapping("/generate")
    public String generate(@RequestParam Long idUtilisateur,
                           @RequestParam String moisAnnee,
                           RedirectAttributes redirectAttributes) {
        FichePaie fichePaie = fichePaieService.generer(idUtilisateur, moisAnnee);
        redirectAttributes.addFlashAttribute("successMessage",
                "Fiche de paie generee pour "
                        + fichePaie.getUtilisateur().getNom()
                        + " "
                        + fichePaie.getUtilisateur().getPrenom());
        return "redirect:/fiches-paie";
    }

    @ModelAttribute("employes")
    public List<Utilisateur> employes() {
        return fichePaieService.findEmployes();
    }
}