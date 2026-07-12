package com.mkalymlam.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.Notification;
import com.mkalymlam.entity.Produit;
import com.mkalymlam.entity.SessionTruck;
import com.mkalymlam.entity.StatutSession;
import com.mkalymlam.entity.TypeNotification;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.repository.NotificationRepository;
import com.mkalymlam.repository.ProduitRepository;
import com.mkalymlam.repository.SessionTruckRepository;
import com.mkalymlam.repository.TypeNotificationRepository;
import com.mkalymlam.repository.UtilisateurRepository;

@Service
public class NotificationService {

    public static final String TYPE_GENERALE = "GENERALE";
    public static final String TYPE_NOUVEAU_PRODUIT = "BOOST_NOUVEAU_PRODUIT";
    public static final String TYPE_POINT_DE_VENTE = "ARRIVEE_POINT_DE_VENTE";

    private final NotificationRepository notificationRepository;
    private final TypeNotificationRepository typeNotificationRepository;
    private final ProduitRepository produitRepository;
    private final SessionTruckRepository sessionTruckRepository;
    private final UtilisateurRepository utilisateurRepository;

    public NotificationService(NotificationRepository notificationRepository,
                               TypeNotificationRepository typeNotificationRepository,
                               ProduitRepository produitRepository,
                               SessionTruckRepository sessionTruckRepository,
                               UtilisateurRepository utilisateurRepository) {
        this.notificationRepository = notificationRepository;
        this.typeNotificationRepository = typeNotificationRepository;
        this.produitRepository = produitRepository;
        this.sessionTruckRepository = sessionTruckRepository;
        this.utilisateurRepository = utilisateurRepository;
    }

    // ==========================================================
    // 6.3.1 - Publier une notification (generale, par l'administrateur)
    // ==========================================================
    @Transactional
    public Notification publier(String titre, String message, Long idAuteur) {
        validerTitreMessage(titre, message);

        Notification notification = new Notification();
        notification.setTypeNotification(findType(TYPE_GENERALE));
        notification.setTitre(titre.trim());
        notification.setMessage(message.trim());
        notification.setAuteur(findAuteurOptionnel(idAuteur));
        notification.setDateHeureEnvoi(LocalDateTime.now());

        return notificationRepository.save(notification);
    }

 
    @Transactional
    public Notification annoncerNouveauProduit(Long idProduit, String titre, String message, Long idAuteur) {
        if (idProduit == null) {
            throw new IllegalArgumentException("Id produit obligatoire");
        }
        Produit produit = produitRepository.findById(idProduit)
                .orElseThrow(() -> new IllegalArgumentException("Produit " + idProduit + " introuvable dans le catalogue"));

        String titreFinal = (titre != null && !titre.isBlank())
                ? titre.trim()
                : "Nouveau produit : " + produit.getNomProduit();
        String messageFinal = (message != null && !message.isBlank())
                ? message.trim()
                : "Decouvrez notre nouveau produit \"" + produit.getNomProduit() + "\" des maintenant !";

        Notification notification = new Notification();
        notification.setTypeNotification(findType(TYPE_NOUVEAU_PRODUIT));
        notification.setTitre(titreFinal);
        notification.setMessage(messageFinal);
        notification.setProduitLie(produit);
        notification.setAuteur(findAuteurOptionnel(idAuteur));
        notification.setDateHeureEnvoi(LocalDateTime.now());

        return notificationRepository.save(notification);
    }

 
    @Transactional
    public Notification annoncerPointDeVente(Long idSession, String message, Long idAuteur) {
        if (idSession == null) {
            throw new IllegalArgumentException("Id session obligatoire");
        }
        SessionTruck session = sessionTruckRepository.findById(idSession)
                .orElseThrow(() -> new IllegalArgumentException("Session " + idSession + " introuvable"));

        StatutSession statut = session.getStatutSession();
        if (statut == null || !"OUVERTE".equalsIgnoreCase(statut.getLibelle())) {
            throw new IllegalArgumentException("Aucune session en cours pour ce truck : impossible de publier l'emplacement");
        }

        String messageFinal = (message != null && !message.isBlank())
                ? message.trim()
                : "Notre Food Truck est actuellement present sur son point de vente.";

        Notification notification = new Notification();
        notification.setTypeNotification(findType(TYPE_POINT_DE_VENTE));
        notification.setTitre("Le Food Truck est arrive !");
        notification.setMessage(messageFinal);
        notification.setSessionLiee(session);
        notification.setAuteur(findAuteurOptionnel(idAuteur));
        notification.setDateHeureEnvoi(LocalDateTime.now());

        return notificationRepository.save(notification);
    }

   
    public List<Notification> findAll() {
        return notificationRepository.findAllByOrderByDateHeureEnvoiDesc();
    }

    public List<Notification> findRecentes(int nombreJours) {
        LocalDateTime depuis = LocalDateTime.now().minusDays(nombreJours);
        return notificationRepository.findByDateHeureEnvoiGreaterThanEqualOrderByDateHeureEnvoiDesc(depuis);
    }

    public List<Notification> findAnciennes(int nombreJours) {
        LocalDateTime avant = LocalDateTime.now().minusDays(nombreJours);
        return notificationRepository.findByDateHeureEnvoiLessThanOrderByDateHeureEnvoiDesc(avant);
    }

    public List<Notification> findByProduit(Long idProduit) {
        Produit produit = produitRepository.findById(idProduit)
                .orElseThrow(() -> new IllegalArgumentException("Produit " + idProduit + " introuvable"));
        return notificationRepository.findByProduitLieOrderByDateHeureEnvoiDesc(produit);
    }

    public List<Notification> findBySession(Long idSession) {
        SessionTruck session = sessionTruckRepository.findById(idSession)
                .orElseThrow(() -> new IllegalArgumentException("Session " + idSession + " introuvable"));
        return notificationRepository.findBySessionLieeOrderByDateHeureEnvoiDesc(session);
    }

    public Notification find(Long id) {
        return notificationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Notification " + id + " introuvable"));
    }

   
    @Transactional
    public Notification modifier(Long id, String titre, String message) {
        Notification notification = find(id);

        if (titre != null && !titre.isBlank()) {
            notification.setTitre(titre.trim());
        }
        if (message != null && !message.isBlank()) {
            notification.setMessage(message.trim());
        }
        notification.setDateModification(LocalDateTime.now());

        return notificationRepository.save(notification);
    }

    @Transactional
    public void delete(Long id) {
        if (!notificationRepository.existsById(id)) {
            throw new IllegalArgumentException("Notification " + id + " introuvable");
        }
        notificationRepository.deleteById(id);
    }

    // ==========================================================
    // Utilitaires
    // ==========================================================
    private void validerTitreMessage(String titre, String message) {
        if (titre == null || titre.isBlank()) {
            throw new IllegalArgumentException("Le titre de la notification est obligatoire");
        }
        if (message == null || message.isBlank()) {
            throw new IllegalArgumentException("Le message de la notification est obligatoire");
        }
    }

    private TypeNotification findType(String libelle) {
        TypeNotification type = typeNotificationRepository.findByLibelle(libelle);
        if (type == null) {
            throw new IllegalArgumentException("Type de notification " + libelle + " introuvable");
        }
        return type;
    }

    private Utilisateur findAuteurOptionnel(Long idAuteur) {
        if (idAuteur == null) {
            return null;
        }
        return utilisateurRepository.findById(idAuteur).orElse(null);
    }
}
