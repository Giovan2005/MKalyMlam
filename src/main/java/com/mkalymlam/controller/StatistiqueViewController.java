package com.mkalymlam.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/statistique")
public class StatistiqueViewController {

    @GetMapping
    public String index() {
        return "statistique/index";
    }
}