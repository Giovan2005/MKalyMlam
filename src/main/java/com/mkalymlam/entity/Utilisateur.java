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
@Table(name = "utilisateur")
public class Utilisateur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idUtilisateur\"")
    private Long id;

    @Column(name = "\"nom\"")
    private String nom;

    @Column(name = "\"prenom\"")
    private String prenom;

    @Column(name = "\"email\"")
    private String email;

    @Column(name = "\"motDePasse\"")
    private String motDePasse;

    @ManyToOne
    @JoinColumn(name = "\"idRole\"")
    private Role role;

    @Column(name = "\"salaireBaseFixe\"")
    private Double salaireBaseFixe;

    @Column(name = "\"statutActif\"")
    private Boolean statutActif;

    public Utilisateur() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Double getSalaireBaseFixe() {
        return salaireBaseFixe;
    }

    public void setSalaireBaseFixe(Double salaireBaseFixe) {
        this.salaireBaseFixe = salaireBaseFixe;
    }

    public Boolean getStatutActif() {
        return statutActif;
    }

    public void setStatutActif(Boolean statutActif) {
        this.statutActif = statutActif;
    }
}
