package com.mkalymlam.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.stereotype.Controller;

import com.mkalymlam.entity.ActionAmelioration;
import com.mkalymlam.entity.StatutDemandeAchat;
import com.mkalymlam.service.ActionAmeliorationService;

@Controller
@RequestMapping("/action")
public class ActionAmeliorationController {

    private final ActionAmeliorationService service;

    public ActionAmeliorationController(ActionAmeliorationService service) {
        this.service = service;
    }

    @PostMapping("/save")
    @ResponseBody
    public ActionAmelioration save(@RequestBody ActionAmelioration action) {
        return service.save(action);
    }

    @PostMapping("/update")
    @ResponseBody
    public ActionAmelioration update(@RequestParam Long idAction,
                                      @RequestParam StatutDemandeAchat statutDemandeAchat) {
        return service.update(idAction, statutDemandeAchat);
    }

    @GetMapping("/findAll")
    @ResponseBody
    public List<ActionAmelioration> findAll() {
        return service.findAll();
    }

    @GetMapping("/findByRetour")
    @ResponseBody
    public List<ActionAmelioration> findByRetour(@RequestParam("id_retour") Long idRetour) {
        return service.findByRetour(idRetour);
    }
}