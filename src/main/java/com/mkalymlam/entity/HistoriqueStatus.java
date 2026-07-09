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
@Table(name = "\"historiqueStatus\"")
public class HistoriqueStatus {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idHistoriqueStatus\"")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "\"idTruck\"")
    private Truck truck;

    @ManyToOne
    @JoinColumn(name = "\"idStatutDisponibilite\"")
    private StatutDisponibilite statutDisponibilite;

    @Column(name = "\"dateChangement\"")
    private LocalDateTime dateChangement;

    public HistoriqueStatus() {}

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

    public StatutDisponibilite getStatutDisponibilite() {
        return statutDisponibilite;
    }

    public void setStatutDisponibilite(StatutDisponibilite statutDisponibilite) {
        this.statutDisponibilite = statutDisponibilite;
    }

    public LocalDateTime getDateChangement() {
        return dateChangement;
    }

    public void setDateChangement(LocalDateTime dateChangement) {
        this.dateChangement = dateChangement;
    }
}
