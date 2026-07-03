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
@Table(name = "\"fichePaie\"")
public class FichePaie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idFiche\"")
    private Long idFiche;

    @ManyToOne
    @JoinColumn(name = "\"idUtilisateur\"")
    private Utilisateur utilisateur;

    @Column(name = "\"moisAnnee\"")
    private String moisAnnee;

    @Column(name = "\"montantFixeBrut\"")
    private Double montantFixeBrut;

    @Column(name = "\"montantNetVerse\"")
    private Double montantNetVerse;

    @Column(name = "\"datePaiement\"")
    private LocalDate datePaiement;

    public FichePaie() {
    }

    public Long getIdFiche() {
        return idFiche;
    }

    public void setIdFiche(Long idFiche) {
        this.idFiche = idFiche;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }

    public String getMoisAnnee() {
        return moisAnnee;
    }

    public void setMoisAnnee(String moisAnnee) {
        this.moisAnnee = moisAnnee;
    }

    public Double getMontantFixeBrut() {
        return montantFixeBrut;
    }

    public void setMontantFixeBrut(Double montantFixeBrut) {
        this.montantFixeBrut = montantFixeBrut;
    }

    public Double getMontantNetVerse() {
        return montantNetVerse;
    }

    public void setMontantNetVerse(Double montantNetVerse) {
        this.montantNetVerse = montantNetVerse;
    }

    public LocalDate getDatePaiement() {
        return datePaiement;
    }

    public void setDatePaiement(LocalDate datePaiement) {
        this.datePaiement = datePaiement;
    }
}