package com.mkalymlam.entity;

import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;


@Entity
@Table(name = "\"demandeChangementItineraire\"")
public class DemandeChangementItineraire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idDemande\"")
    private Long idDemande;
    @ManyToOne
    @JoinColumn(name = "\"idSession\"")
    private SessionTruck sessionTruck;

    @ManyToOne
    @JoinColumn(name = "\"idDemandeur\"")
    private Utilisateur demandeur;

    @Column(name = "\"raison\"")
    private String raison;

    @ManyToOne
    @JoinColumn(name = "\"idItinerairePropose\"")
    private Itineraire itinerairePropose;

    @Column(name = "\"autreLieuPrecise\"")
    private String autreLieuPrecise;

    @Column(name = "\"dateHeureDemande\"")
    private LocalDateTime dateHeureDemande;

    @ManyToOne
    @JoinColumn(name = "\"idStatutValidation\"")
    private StatutValidation statutValidation;

    public Long getIdDemande() {
        return idDemande;
    }

    public void setIdDemande(Long idDemande) {
        this.idDemande = idDemande;
    }

    public SessionTruck getSessionTruck() {
        return sessionTruck;
    }

    public void setSessionTruck(SessionTruck sessionTruck) {
        this.sessionTruck = sessionTruck;
    }

    public Utilisateur getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(Utilisateur demandeur) {
        this.demandeur = demandeur;
    }

    public String getRaison() {
        return raison;
    }

    public void setRaison(String raison) {
        this.raison = raison;
    }

    public Itineraire getItinerairePropose() {
        return itinerairePropose;
    }

    public void setItinerairePropose(Itineraire itinerairePropose) {
        this.itinerairePropose = itinerairePropose;
    }

    public String getAutreLieuPrecise() {
        return autreLieuPrecise;
    }

    public void setAutreLieuPrecise(String autreLieuPrecise) {
        this.autreLieuPrecise = autreLieuPrecise;
    }

    public LocalDateTime getDateHeureDemande() {
        return dateHeureDemande;
    }

    public void setDateHeureDemande(LocalDateTime dateHeureDemande) {
        this.dateHeureDemande = dateHeureDemande;
    }

    public StatutValidation getStatutValidation() {
        return statutValidation;
    }

    public void setStatutValidation(StatutValidation statutValidation) {
        this.statutValidation = statutValidation;
    }

}
