package com.mkalymlam.entity;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "\"statutValidation\"")
public class StatutValidation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idStatutValidation\"")
    private Long idStatutValidation;

    @Column(name = "\"libelle\"")
    private String libelle;

    public Long getIdStatutValidation() {
        return idStatutValidation;
    }

    public void setIdStatutValidation(Long idStatutValidation) {
        this.idStatutValidation = idStatutValidation;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}