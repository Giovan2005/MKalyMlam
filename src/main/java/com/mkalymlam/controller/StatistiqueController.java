package com.mkalymlam.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.stereotype.Controller;

import com.mkalymlam.service.StatistiqueService;

// Même pattern que ProduitController / IngredientController : un seul
// @Controller, la page HTML dans une méthode normale (retourne le nom de vue),
// et les endpoints JSON annotés @ResponseBody. Plus de StatistiqueViewController
// séparé : tout est ici, comme pour toutes les autres pages de l'appli.
@Controller
public class StatistiqueController {

    @Autowired
    private StatistiqueService statistiqueService;

    // ----------------------------------------------------------------
    // Page HTML
    // ----------------------------------------------------------------

    @GetMapping("/statistique")
    public String index() {
        return "statistique/index";
    }

    // ----------------------------------------------------------------
    // Endpoints JSON (préfixe /statistiques, comme avant)
    // ----------------------------------------------------------------

    @GetMapping("/statistiques/chiffreAffaire")
    @ResponseBody
    public Double chiffreAffaire(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        return statistiqueService.getChiffreAffaireGlobal(dateDebut, dateFin);
    }

    @GetMapping("/statistiques/benefice")
    @ResponseBody
    public Double benefice(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        return statistiqueService.getBeneficeTotal(dateDebut, dateFin);
    }

    @GetMapping("/statistiques/benefice/{idItineraire}")
    @ResponseBody
    public Double beneficeParItineraire(@PathVariable Long idItineraire) {
        return statistiqueService.getBeneficeByIdItineraire(idItineraire);
    }

    // Ajout du paramètre "granularite" (jour/semaine/mois) pour les boutons
    // Journalier / Hebdomadaire / Mensuel du front. Par défaut "jour", donc
    // un appel sans ce paramètre se comporte exactement comme avant.
    @GetMapping("/statistiques/graphique")
    @ResponseBody
    public List<Map<String, Object>> graphique(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
            @RequestParam(required = false, defaultValue = "jour") String granularite) {
        return statistiqueService.getDonneesGraphique(dateDebut, dateFin, granularite);
    }

    @GetMapping("/statistiques/chiffreAffaire/parSession/{idSession}")
    @ResponseBody
    public Double chifferAffaireParSession(@PathVariable Long idSession) {
        return statistiqueService.getChiffreAffaireByIdSession(idSession);
    }

    @GetMapping("/statistiques/chiffreAffaire/parZone/{nomZone}")
    @ResponseBody
    public Double chifferAffaireParZone(@PathVariable String nomZone) {
        return statistiqueService.getChiffreAffaireByZone(nomZone);
    }

    @GetMapping("/statistiques/chiffreAffaire/parSession/hebdomadaire/{idSession}")
    @ResponseBody
    public Double chifferAffaireParSessionHebdomadaire(@PathVariable Long idSession) {
        return statistiqueService.getChiffreAffaireByIdSessionHebdomadaire(idSession);
    }

    @GetMapping("/statistiques/chiffreAffaire/parSession/{idSession}/{date1}/{date2}")
    @ResponseBody
    public Double chifferAffaireParSession2Dates(
            @PathVariable Long idSession,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime date1,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime date2) {
        return statistiqueService.getChiffreAffaireByIdSessionDates(idSession, date1, date2);
    }

    @GetMapping("/statistiques/chiffreAffaire/parSession/mensuel/{idSession}")
    @ResponseBody
    public Double chifferAffaireParSessionMensuel(@PathVariable Long idSession) {
        return statistiqueService.getChiffreAffaireByIdSessionMensuel(idSession);
    }

    // Liste des zones distinctes. Pas utilisé par le front pour le moment
    // (zone volontairement retirée de cette itération), gardé disponible.
    @GetMapping("/statistiques/zones")
    @ResponseBody
    public List<String> zones() {
        return statistiqueService.getZones();
    }

    @GetMapping("/statistiques/benefice/zone/{nomZone}")
    @ResponseBody
    public Double beneficeParZone(@PathVariable String nomZone) {
        return statistiqueService.getBeneficeByZone(nomZone);
    }

    @GetMapping("/statistiques/chiffreAffaire/parZone")
    @ResponseBody
    public List<Map<String, Object>> chiffreAffaireParZoneGroupe(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        return statistiqueService.getChiffreAffaireParZoneGroupe(dateDebut, dateFin);
    }

    @GetMapping("/statistiques/benefice/parZone")
    @ResponseBody
    public List<Map<String, Object>> beneficeParZoneGroupe(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        return statistiqueService.getBeneficeParZoneGroupe(dateDebut, dateFin);
    }
}