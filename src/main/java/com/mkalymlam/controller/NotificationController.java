package com.mkalymlam.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mkalymlam.entity.Notification;
import com.mkalymlam.entity.Produit;
import com.mkalymlam.entity.SessionTruck;
import com.mkalymlam.repository.ProduitRepository;
import com.mkalymlam.repository.SessionTruckRepository;
import com.mkalymlam.service.NotificationService;

@Controller
@RequestMapping("/notification")
public class NotificationController {

    private static final Logger log = LoggerFactory.getLogger(NotificationController.class);

    private final NotificationService notificationService;
    private final ProduitRepository produitRepository;
    private final SessionTruckRepository sessionTruckRepository;

    public NotificationController(NotificationService notificationService,
                                  ProduitRepository produitRepository,
                                  SessionTruckRepository sessionTruckRepository) {
        this.notificationService = notificationService;
        this.produitRepository = produitRepository;
        this.sessionTruckRepository = sessionTruckRepository;
    }

  
    @PostMapping("/publier")
    @ResponseBody
    public Notification publier(@RequestParam String titre,
                                @RequestParam String message,
                                @RequestParam(required = false) Long idAuteur) {
        return notificationService.publier(titre, message, idAuteur);
    }

    @PostMapping("/annoncerProduit")
    @ResponseBody
    public Notification annoncerProduit(@RequestParam Long idProduit,
                                        @RequestParam(required = false) String titre,
                                        @RequestParam(required = false) String message,
                                        @RequestParam(required = false) Long idAuteur) {
        return notificationService.annoncerNouveauProduit(idProduit, titre, message, idAuteur);
    }

  
    @PostMapping("/annoncerPointDeVente")
    @ResponseBody
    public Notification annoncerPointDeVente(@RequestParam Long idSession,
                                             @RequestParam(required = false) String message,
                                             @RequestParam(required = false) Long idAuteur) {
        return notificationService.annoncerPointDeVente(idSession, message, idAuteur);
    }

  
    @PostMapping("/modifier")
    @ResponseBody
    public Notification modifier(@RequestParam Long id,
                                 @RequestParam(required = false) String titre,
                                 @RequestParam(required = false) String message) {
        return notificationService.modifier(id, titre, message);
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam Long id) {
        notificationService.delete(id);
        return "OK";
    }

    @GetMapping("/find")
    @ResponseBody
    public Notification find(@RequestParam Long id) {
        return notificationService.find(id);
    }

    
    @GetMapping("/findAll")
    @ResponseBody
    public List<Notification> findAll() {
        return notificationService.findAll();
    }

    @GetMapping("/recentes")
    @ResponseBody
    public List<Notification> recentes(@RequestParam(defaultValue = "7") int jours) {
        return notificationService.findRecentes(jours);
    }

    @GetMapping("/anciennes")
    @ResponseBody
    public List<Notification> anciennes(@RequestParam(defaultValue = "7") int jours) {
        return notificationService.findAnciennes(jours);
    }

    @GetMapping("/produit/{idProduit}")
    @ResponseBody
    public List<Notification> parProduit(@org.springframework.web.bind.annotation.PathVariable Long idProduit) {
        return notificationService.findByProduit(idProduit);
    }

    @GetMapping("/session/{idSession}")
    @ResponseBody
    public List<Notification> parSession(@org.springframework.web.bind.annotation.PathVariable Long idSession) {
        return notificationService.findBySession(idSession);
    }

    
    @GetMapping("/gestion_notification")
    public String gestion(Model model) {
        try {
            model.addAttribute("notifications", notificationService.findAll());
            model.addAttribute("produits", produitRepository.findAll());
            model.addAttribute("sessions", sessionTruckRepository.findAll());
        } catch (Exception e) {
            log.error("Erreur dans gestion_notification", e);
            model.addAttribute("notifications", List.of());
            model.addAttribute("produits", List.of());
            model.addAttribute("sessions", List.of());
        }
        return "notification/gestion_notification";
    }

   
    @GetMapping("/consultation")
    public String consultation(@RequestParam(required = false) String filtre,
                               @RequestParam(required = false) Long idProduit,
                               @RequestParam(required = false) Long idSession,
                               Model model) {
        List<Notification> notifications;
        try {
            if ("recentes".equals(filtre)) {
                notifications = notificationService.findRecentes(7);
            } else if ("anciennes".equals(filtre)) {
                notifications = notificationService.findAnciennes(7);
            } else if ("produit".equals(filtre) && idProduit != null) {
                notifications = notificationService.findByProduit(idProduit);
            } else if ("session".equals(filtre) && idSession != null) {
                notifications = notificationService.findBySession(idSession);
            } else {
                notifications = notificationService.findAll();
            }
        } catch (Exception e) {
            log.error("Erreur dans consultation notification", e);
            notifications = List.of();
        }

        model.addAttribute("notifications", notifications);
        model.addAttribute("selectedFiltre", filtre);
        model.addAttribute("selectedIdProduit", idProduit);
        model.addAttribute("selectedIdSession", idSession);

        List<Produit> produits;
        List<SessionTruck> sessions;
        try {
            produits = produitRepository.findAll();
        } catch (Exception e) {
            produits = List.of();
        }
        try {
            sessions = sessionTruckRepository.findAll();
        } catch (Exception e) {
            sessions = List.of();
        }
        model.addAttribute("produits", produits);
        model.addAttribute("sessions", sessions);

        return "notification/consultation";
    }
}
