package com.mkalymlam.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    @GetMapping({ "/", "/dashboard", "/dashboard-statistique" })
    public String dashboardStatistique(Model model) {
        model.addAttribute("titre", "Dashboard statistique");
        return "dashboard/dashboard";
    }
}


