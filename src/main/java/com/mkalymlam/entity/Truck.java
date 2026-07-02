package com.mkalymlam.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "truck")
public class Truck {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idTruck\"")
    private Long id;

    @Column(name = "\"immatriculation\"")
    private String immatriculation;

    @ManyToOne
    @JoinColumn(name = "\"idStatutDisponibilite\"")
    private StatutDisponibilite statutDisponibilite;

    public Truck() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getImmatriculation() {
        return immatriculation;
    }

    public void setImmatriculation(String immatriculation) {
        this.immatriculation = immatriculation;
    }

    public StatutDisponibilite getStatutDisponibilite() {
        return statutDisponibilite;
    }

    public void setStatutDisponibilite(StatutDisponibilite statutDisponibilite) {
        this.statutDisponibilite = statutDisponibilite;
    }
}
