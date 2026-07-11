package com.mkalymlam.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

import com.mkalymlam.entity.EquipeSession;
import com.mkalymlam.entity.SessionTruck;
import com.mkalymlam.service.EquipeSessionService;
import com.mkalymlam.service.SessionTruckService;
import com.mkalymlam.service.CsvExcelImportService;
import com.mkalymlam.repository.RoleRepository;
import com.mkalymlam.repository.UtilisateurRepository;

@Controller
@RequestMapping("/equipe")
public class EquipeSessionController {

    private final EquipeSessionService equipeSessionService;
    private final SessionTruckService sessionTruckService;
    private final CsvExcelImportService csvExcelImportService;
    private final UtilisateurRepository utilisateurRepository;
    private final RoleRepository roleRepository;

    public EquipeSessionController(EquipeSessionService equipeSessionService,
                                   SessionTruckService sessionTruckService,
                                   CsvExcelImportService csvExcelImportService,
                                   UtilisateurRepository utilisateurRepository,
                                   RoleRepository roleRepository) {
        this.equipeSessionService = equipeSessionService;
        this.sessionTruckService = sessionTruckService;
        this.csvExcelImportService = csvExcelImportService;
        this.utilisateurRepository = utilisateurRepository;
        this.roleRepository = roleRepository;
    }

    @GetMapping("affecter")
    public String pageGestion(Model model) {
        List<SessionTruck> toutesSessions = sessionTruckService.findSessionsDuJour();
        model.addAttribute("sessions", toutesSessions);
        model.addAttribute("utilisateurs", utilisateurRepository.findAll());
        model.addAttribute("roles", roleRepository.findAll());
        model.addAttribute("equipeSessions", equipeSessionService.getAllEquipeSessions());
        return "equipe/ajouterEquipe";
    }

    @PostMapping("/affecter")
    public String affecter(@RequestParam Long idSession,
                           @RequestParam(required = false) List<Long> idUtilisateur,
                           @RequestParam(required = false) List<Long> roleDuJour,
                           @RequestParam(required = false) List<Double> salaireJournalierRemplacant,
                           RedirectAttributes redirectAttributes) {
        try {
            if (idUtilisateur != null && !idUtilisateur.isEmpty()) {
                equipeSessionService.affecterPlusieurs(idSession, idUtilisateur, roleDuJour, salaireJournalierRemplacant);
            }
            redirectAttributes.addFlashAttribute("success", (idUtilisateur != null ? idUtilisateur.size() : 0) + " employe(s) affecte(s) avec succes");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/equipe/list_equipe";
    }

    @PostMapping("/retirer")
    public String retirer(@RequestParam Long idSession,
                          @RequestParam Long idUtilisateur,
                          RedirectAttributes redirectAttributes) {
        try {
            equipeSessionService.retirer(idSession, idUtilisateur);
            redirectAttributes.addFlashAttribute("success", "Employe retire avec succes");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/equipe/list_equipe";
    }

    @GetMapping("/list_equipe")
    public String listEquipe(@RequestParam(required = false) Long sessionId,
                             @RequestParam(required = false) Long roleId,
                             @RequestParam(required = false) String nomEmploye,
                             @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateSession,
                             Model model) {
        List<EquipeSession> equipeSessions = equipeSessionService.getFilteredEquipeSessions(sessionId, roleId, nomEmploye, dateSession);
        model.addAttribute("equipeSessions", equipeSessions);
        model.addAttribute("sessions", sessionTruckService.findAll());
        model.addAttribute("roles", roleRepository.findAll());
        model.addAttribute("selectedSessionId", sessionId);
        model.addAttribute("selectedRoleId", roleId);
        model.addAttribute("selectedNomEmploye", nomEmploye);
        model.addAttribute("selectedDateSession", dateSession);
        return "equipe/listEquipe";
    }

    @GetMapping("/findBySession")
    @ResponseBody
    public List<EquipeSession> findBySession(@RequestParam Long idSession) {
        return equipeSessionService.getEquipeSessionsBySessionTruckId(idSession);
    }

    @GetMapping("/findAll")
    @ResponseBody
    public List<EquipeSession> findAll() {
        return equipeSessionService.getAllEquipeSessions();
    }

    @GetMapping("/import")
    public String pageImport(Model model) {
        return "equipe/import";
    }

    @PostMapping("/import")
    public String importData(@RequestParam("file") MultipartFile file,
                             RedirectAttributes redirectAttributes) {
        try {
            List<String> erreurs = csvExcelImportService.importFile(file, "equipe");
            if (erreurs.isEmpty()) {
                redirectAttributes.addFlashAttribute("success",
                    "Affectation(s) importee(s) avec succes");
            } else {
                redirectAttributes.addFlashAttribute("warning",
                    "Erreurs : " + String.join("; ", erreurs));
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                "Erreur lors de l'import : " + e.getMessage());
        }
        return "redirect:/equipe/list_equipe";
    }
}
