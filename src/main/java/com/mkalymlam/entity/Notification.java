package com.mkalymlam.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "\"notificationPlateforme\"")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idNotification\"")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "\"idTypeNotification\"")
    private TypeNotification typeNotification;

    @Column(name = "\"titre\"")
    private String titre;

    @Column(name = "\"message\"")
    private String message;

    @ManyToOne
    @JoinColumn(name = "\"idProduitLie\"")
    private Produit produitLie;

    @ManyToOne
    @JoinColumn(name = "\"idSessionLiee\"")
    private SessionTruck sessionLiee;

    @ManyToOne
    @JoinColumn(name = "\"idAuteur\"")
    private Utilisateur auteur;

    @Column(name = "\"dateHeureEnvoi\"")
    private LocalDateTime dateHeureEnvoi;

    @Column(name = "\"dateModification\"")
    private LocalDateTime dateModification;

    public Notification() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public TypeNotification getTypeNotification() {
        return typeNotification;
    }

    public void setTypeNotification(TypeNotification typeNotification) {
        this.typeNotification = typeNotification;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Produit getProduitLie() {
        return produitLie;
    }

    public void setProduitLie(Produit produitLie) {
        this.produitLie = produitLie;
    }

    public SessionTruck getSessionLiee() {
        return sessionLiee;
    }

    public void setSessionLiee(SessionTruck sessionLiee) {
        this.sessionLiee = sessionLiee;
    }

    public Utilisateur getAuteur() {
        return auteur;
    }

    public void setAuteur(Utilisateur auteur) {
        this.auteur = auteur;
    }

    public LocalDateTime getDateHeureEnvoi() {
        return dateHeureEnvoi;
    }

    public void setDateHeureEnvoi(LocalDateTime dateHeureEnvoi) {
        this.dateHeureEnvoi = dateHeureEnvoi;
    }

    public LocalDateTime getDateModification() {
        return dateModification;
    }

    public void setDateModification(LocalDateTime dateModification) {
        this.dateModification = dateModification;
    }
}
