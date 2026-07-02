package com.mkalymlam.entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "\"sessionTruck\"")
public class SessionTruck {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idSession\"")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "\"idTruck\"")
    private Truck truck;

    @ManyToOne
    @JoinColumn(name = "\"idItineraire\"")
    private Itineraire itineraire;

    @Column(name = "\"dateSession\"")
    private LocalDate dateSession;

    @Column(name = "\"fondDeCaisseOuverture\"")
    private Double fondDeCaisseOuverture;

    @Column(name = "\"fondDeCaisseCloture\"")
    private Double fondDeCaisseCloture;

    @Column(name = "\"chiffreAffaireTotal\"")
    private Double chiffreAffaireTotal;

    @Column(name = "\"commissionTotaleEquipe\"")
    private Double commissionTotaleEquipe;

    @ManyToOne
    @JoinColumn(name = "\"idStatutSession\"")
    private StatutSession statutSession;

    public SessionTruck() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Truck getTruck() {
        return truck;
    }

    public void setTruck(Truck truck) {
        this.truck = truck;
    }

    public Itineraire getItineraire() {
        return itineraire;
    }

    public void setItineraire(Itineraire itineraire) {
        this.itineraire = itineraire;
    }

    public LocalDate getDateSession() {
        return dateSession;
    }

    public void setDateSession(LocalDate dateSession) {
        this.dateSession = dateSession;
    }

    public Double getFondDeCaisseOuverture() {
        return fondDeCaisseOuverture;
    }

    public void setFondDeCaisseOuverture(Double fondDeCaisseOuverture) {
        this.fondDeCaisseOuverture = fondDeCaisseOuverture;
    }

    public Double getFondDeCaisseCloture() {
        return fondDeCaisseCloture;
    }

    public void setFondDeCaisseCloture(Double fondDeCaisseCloture) {
        this.fondDeCaisseCloture = fondDeCaisseCloture;
    }

    public Double getChiffreAffaireTotal() {
        return chiffreAffaireTotal;
    }

    public void setChiffreAffaireTotal(Double chiffreAffaireTotal) {
        this.chiffreAffaireTotal = chiffreAffaireTotal;
    }

    public Double getCommissionTotaleEquipe() {
        return commissionTotaleEquipe;
    }

    public void setCommissionTotaleEquipe(Double commissionTotaleEquipe) {
        this.commissionTotaleEquipe = commissionTotaleEquipe;
    }

    public StatutSession getStatutSession() {
        return statutSession;
    }

    public void setStatutSession(StatutSession statutSession) {
        this.statutSession = statutSession;
    }
}
