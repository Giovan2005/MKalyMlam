package com.mkalymlam.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mkalymlam.entity.ClassificationSentiment;
import com.mkalymlam.entity.RetourClient;
import com.mkalymlam.service.RetourClientService;

@Controller
@RequestMapping("/retour")
public class RetourClientController {

    private final RetourClientService service;

    public RetourClientController(RetourClientService service) {
        this.service = service;
    }

    @GetMapping
    public String form() {
        return "retourClient/form";
    }

    @PostMapping("/save")
    @ResponseBody
    public RetourClient save(@RequestBody RetourClient retour) {
        return service.save(retour);
    }

    @GetMapping("/findAll")
    @ResponseBody
    public List<RetourClient> findAll() {
        return service.findAll();
    }

    @GetMapping("/findBysentiment")
    @ResponseBody
    public List<RetourClient> findBySentiment(@RequestParam String sentiment) {
        return service.findBySentiment(ClassificationSentiment.valueOf(sentiment.toUpperCase()));
    }

    @GetMapping("/populaires")
    @ResponseBody
    public List<RetourClient> populaires() {
        return service.findPopulaires();
    }

    @GetMapping("/avis")
    public String avisPage(org.springframework.ui.Model model) {
        model.addAttribute("retours", service.findAvis());
        return "retourClient/avis";
    }

    @GetMapping("/demandes")
    public String demandesPage(org.springframework.ui.Model model) {
        model.addAttribute("retours", service.findDemandes());
        return "retourClient/demandes";
    }

    @GetMapping("/listeAvis")
    @ResponseBody
    public List<RetourClient> listeAvis() {
        return service.findAvis();
    }

    @GetMapping("/listeDemandes")
    @ResponseBody
    public List<RetourClient> listeDemandes() {
        return service.findDemandes();
    }
}
