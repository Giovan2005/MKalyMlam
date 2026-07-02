package com.mkalymlam.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.stereotype.Controller;

import com.mkalymlam.entity.Truck;
import com.mkalymlam.service.TruckService;

@Controller
@RequestMapping("/truck")
public class TruckController {

    private final TruckService truckService;

    public TruckController(TruckService truckService) {
        this.truckService = truckService;
    }

    @PostMapping("/save")
    @ResponseBody
    public Truck save(@RequestParam String immatriculation,
                      @RequestParam(required = false) String statut) {
        return truckService.save(immatriculation, statut);
    }

    @PostMapping("/update")
    @ResponseBody
    public Truck update(@RequestParam Long id,
                        @RequestParam(required = false) String immatriculation,
                        @RequestParam(required = false) String statut) {
        return truckService.update(id, immatriculation, statut);
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam Long id) {
        truckService.delete(id);
        return "OK";
    }

    @GetMapping("/find")
    @ResponseBody
    public Truck find(@RequestParam Long id) {
        return truckService.find(id);
    }

    @GetMapping("/findAll")
    @ResponseBody
    public List<Truck> findAll() {
        return truckService.findAll();
    }

    @GetMapping("/disponibles")
    @ResponseBody
    public List<Truck> disponibles() {
        return truckService.findDisponibles();
    }
}
