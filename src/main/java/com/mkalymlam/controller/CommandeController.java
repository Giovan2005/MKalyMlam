package com.mkalymlam.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mkalymlam.entity.Commande;
import com.mkalymlam.entity.LigneCommande;
import com.mkalymlam.service.VenteService;

@RestController
@RequestMapping("/commande")
public class CommandeController {

    private final VenteService venteService;

    public CommandeController(VenteService venteService) {
        this.venteService = venteService;
    }

    // @PostMapping("/ajouter")
    // @ResponseBody
    // public Commande ajouter(@RequestBody Commande commande) {
    //     return venteService.ajouterCommande(commande);
    // }

    @PostMapping("/ajouter")
    public Commande ajouter(@RequestBody Commande commande) {

        commande.setDateHeureCreation(LocalDateTime.now());

        return venteService.ajouterCommande(commande);
    }

    @GetMapping("/montant")
    public double getMontant(@RequestParam Long id) {
        return venteService.getMontantCommande(id);
    }

    @PostMapping("/valider")
    public Commande valider(@RequestParam Long idCommande, @RequestBody List<LigneCommande> lignes) {
        return venteService.validerCommande(idCommande, lignes);
    }
}
