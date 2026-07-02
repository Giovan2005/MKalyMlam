package com.mkalymlam.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.stereotype.Controller;

import com.mkalymlam.entity.Ingredient;
import com.mkalymlam.entity.LotIngredient;
import com.mkalymlam.service.LotIngredientService;

@Controller
@RequestMapping("/lot")
public class LotIngredientController {

    private final LotIngredientService service;

    public LotIngredientController(LotIngredientService service) {
        this.service = service;
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("lot", new LotIngredient());
        model.addAttribute("ingredients", service.getAllIngredients());
        model.addAttribute("isEdit", false);
        model.addAttribute("actionUrl", "/lot/save");
        return "lot/form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute LotIngredient lotIngredient) {
        service.save(lotIngredient);
        return "redirect:/lot/findAll";
    }

    @GetMapping("/update/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        LotIngredient lot = service.getById(id);
        if (lot == null) {
            return "redirect:/lot/findAll";
        }
        model.addAttribute("lot", lot);
        model.addAttribute("ingredients", service.getAllIngredients());
        model.addAttribute("isEdit", true);
        model.addAttribute("actionUrl", "/lot/update/" + id);
        return "lot/form";
    }

    @PostMapping("/update/{id}")
    public String update(@PathVariable Long id, @ModelAttribute LotIngredient lotIngredient) {
        service.update(id, lotIngredient);
        return "redirect:/lot/findAll";
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
    public String findAll(
            @RequestParam(required = false) String nomIngredient,
            @RequestParam(required = false) Boolean alerte,
            Model model) {
        
        List<LotIngredient> lots;
        
        // filtre par nom si il y a un ingrédient lors de la recherche
        if (nomIngredient != null && !nomIngredient.isEmpty()) {
            lots = service.findByIngredientName(nomIngredient);
        } else {
            lots = service.getAllWithAlertStatus();
        }
        
        // si le filtre alerte est activé, on filtre les lots en alerte
        if (alerte != null && alerte) {
            lots = lots.stream()
                    .filter(lot -> service.verifierAlerte(lot))
                    .collect(Collectors.toList());
        }
    
        model.addAttribute("lots", lots);
        return "lot/list";
    }

    @GetMapping("/alertes")
    public String alertes(Model model) {
        List<LotIngredient> lots = service.getAlertLots();
        model.addAttribute("lots", lots);
        return "alertes/list";
    }
}
