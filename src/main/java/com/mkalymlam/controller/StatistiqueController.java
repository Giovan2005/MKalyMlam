package com.mkalymlam.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mkalymlam.service.StatistiqueService;

@RestController
@RequestMapping("/statistiques")
public class StatistiqueController {

    @Autowired
    private StatistiqueService statistiqueService;

    @GetMapping("/chiffreAffaire")
    public Double chiffreAffaire(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        return statistiqueService.getChiffreAffaireGlobal(dateDebut, dateFin);
    }

    @GetMapping("/benefice")
    public Double benefice(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        return statistiqueService.getBeneficeTotal(dateDebut, dateFin);
    }

    @GetMapping("/benefice/{idItineraire}")
    public Double beneficeParItineraire(@PathVariable Long idItineraire) {
        return statistiqueService.getBeneficeByIdItineraire(idItineraire);
    }

    @GetMapping("/graphique")
    public List<Map<String, Object>> graphique(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        return statistiqueService.getDonneesGraphique(dateDebut, dateFin);
    }

    @GetMapping("chiffreAffaire/parSession/{idSession}")
    public Double chifferAffaireParSession(@PathVariable Long idSession) {
        return statistiqueService.getChiffreAffaireByIdSession(idSession);
    }

    @GetMapping("/chiffreAffaire/parZone/{nomZone}")
    public Double chifferAffaireParZone(@PathVariable String nomZone) {
        return statistiqueService.getChiffreAffaireByZone(nomZone);
    }

    @GetMapping("chiffreAffaire/parSession/hebdomadaire/{idSession}")
    public Double chifferAffaireParSessionHebdomadaire(@PathVariable Long idSession) {
        return statistiqueService.getChiffreAffaireByIdSessionHebdomadaire(idSession);
    }

    @GetMapping("chiffreAffaire/parSession/{idSession}/{date1}/{date2}")
    public Double chifferAffaireParSession2Dates(@PathVariable Long idSession, @PathVariable LocalDateTime date1, @PathVariable LocalDateTime date2) {
        return statistiqueService.getChiffreAffaireByIdSessionDates(idSession, date1, date2);
    }

    @GetMapping("chiffreAffaire/parSession/mensuel/{idSession}")
    public Double chifferAffaireParSessionMensuel(@PathVariable Long idSession) {
        return statistiqueService.getChiffreAffaireByIdSessionMensuel(idSession);
    }

    // ==================================================================
    // AJOUTS - nécessaires pour le filtre par zone côté front.
    // Aucun endpoint existant ci-dessus n'a été modifié.
    // ==================================================================

    // Liste des zones distinctes, pour peupler le <select> "Zone" du filtre
    @GetMapping("/zones")
    public List<String> zones() {
        return statistiqueService.getZones();
    }

    // Le service exposait déjà getBeneficeByZone() mais aucun endpoint ne
    // l'appelait : on se contente de le brancher, sans toucher au service.
    @GetMapping("/benefice/zone/{nomZone}")
    public Double beneficeParZone(@PathVariable String nomZone) {
        return statistiqueService.getBeneficeByZone(nomZone);
    }

    // Endpoint demandé par le cahier des charges : toutes les zones en une
    // seule requête groupée (SessionTruck -> Itineraire -> Commande),
    // avec filtre de dates optionnel. Coexiste avec /parZone/{nomZone}.
    @GetMapping("/chiffreAffaire/parZone")
    public List<Map<String, Object>> chiffreAffaireParZoneGroupe(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        return statistiqueService.getChiffreAffaireParZoneGroupe(dateDebut, dateFin);
    }

    @GetMapping("/benefice/parZone")
    public List<Map<String, Object>> beneficeParZoneGroupe(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        return statistiqueService.getBeneficeParZoneGroupe(dateDebut, dateFin);
    }
}