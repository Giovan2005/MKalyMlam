package com.mkalymlam.controller;

import java.util.List;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.stereotype.Controller;

import com.mkalymlam.entity.LotIngredient;
import com.mkalymlam.service.LotIngredientService;

@Controller
@RequestMapping("/lot")
public class LotIngredientController {

    private final LotIngredientService service;

    public LotIngredientController(LotIngredientService service) {
        this.service = service;
    }

    @PostMapping("/save")
    public LotIngredient save(@RequestBody LotIngredient lotIngredient) {
        return service.save(lotIngredient);
    }

    @PutMapping("/update/{id}")
    public LotIngredient update(@PathVariable Long id, @RequestBody LotIngredient lotIngredient) {
        return service.update(id, lotIngredient);
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        service.deleteById(id);
        return "redirect:/lot/findAll";
    }

    @GetMapping("/find")
    public List<LotIngredient> find(
            @RequestParam(required = false) Long idLot,
            @RequestParam(required = false) String nomIngredient) {
        if (idLot != null) {
            LotIngredient lot = service.getById(idLot);
            return lot == null ? List.of() : List.of(lot);
        }
        if (nomIngredient != null && !nomIngredient.isBlank()) {
            return service.findByIngredientName(nomIngredient);
        }
        return service.getAll();
    }

    @GetMapping("/findAll")
    public String findAll(Model model) {
        model.addAttribute("lots", service.getAllWithAlertStatus());
        return "lot/list";
    }

    @GetMapping("/alertes")
    public String alertes(Model model) {
        List<LotIngredient> lots = service.getAlertLots();
        model.addAttribute("lots", lots);
        return "alertes/list";
    }
}
