package com.mkalymlam.entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "\"lotIngredient\"")
public class LotIngredient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idLot\"")
    private Long idLot;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "\"idIngredient\"")
    private Ingredient ingredient;

    @Column(name = "\"dateReception\"")
    private LocalDate dateReception;

    @Column(name = "\"datePeremption\"")
    private LocalDate datePeremption;

    @Column(name = "\"quantiteInitiale\"")
    private Double quantiteInitiale;

    @Column(name = "\"quantiteRestante\"")
    private Double quantiteRestante;

    @Column(name = "\"prixAchatUnitaire\"")
    private Double prixAchatUnitaire;

    @Transient  // Ne pas persister en base
    private boolean alerte;
    
    public boolean isAlerte() {
        return alerte;
    }
    
    public void setAlerte(boolean alerte) {
        this.alerte = alerte;
    }

    public LotIngredient() {
    }

    public LotIngredient(Ingredient ingredient, LocalDate dateReception, LocalDate datePeremption,
            Double quantiteInitiale, Double quantiteRestante, Double prixAchatUnitaire) {
        this.ingredient = ingredient;
        this.dateReception = dateReception;
        this.datePeremption = datePeremption;
        this.quantiteInitiale = quantiteInitiale;
        this.quantiteRestante = quantiteRestante;
        this.prixAchatUnitaire = prixAchatUnitaire;
    }

    public Long getIdLot() {
        return idLot;
    }

    public void setIdLot(Long idLot) {
        this.idLot = idLot;
    }

    public Ingredient getIngredient() {
        return ingredient;
    }

    public void setIngredient(Ingredient ingredient) {
        this.ingredient = ingredient;
    }

    public LocalDate getDateReception() {
        return dateReception;
    }

    public void setDateReception(LocalDate dateReception) {
        this.dateReception = dateReception;
    }

    public LocalDate getDatePeremption() {
        return datePeremption;
    }

    public void setDatePeremption(LocalDate datePeremption) {
        this.datePeremption = datePeremption;
    }

    public Double getQuantiteInitiale() {
        return quantiteInitiale;
    }

    public void setQuantiteInitiale(Double quantiteInitiale) {
        this.quantiteInitiale = quantiteInitiale;
    }

    public Double getQuantiteRestante() {
        return quantiteRestante;
    }

    public void setQuantiteRestante(Double quantiteRestante) {
        this.quantiteRestante = quantiteRestante;
    }

    public Double getPrixAchatUnitaire() {
        return prixAchatUnitaire;
    }

    public void setPrixAchatUnitaire(Double prixAchatUnitaire) {
        this.prixAchatUnitaire = prixAchatUnitaire;
    }
}
