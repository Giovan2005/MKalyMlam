package com.mkalymlam.entity;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "utilisateur")
@Data
public class Utilisateur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idUtilisateur\"")
    private Integer idUtilisateur;

    @Column(name = "\"nom\"", nullable = false, length = 100)
    private String nom;

    @Column(name = "\"prenom\"", length = 100)
    private String prenom;

    @Column(name = "\"email\"", nullable = false, unique = true, length = 150)
    private String email;

    @Column(name = "\"motDePasse\"", nullable = false, length = 255)
    private String motDePasse;

    @Column(name = "\"idRole\"", nullable = false)
    private Integer idRole;

    @Column(name = "\"salaireBaseFixe\"")
    private BigDecimal salaireBaseFixe;

    @Column(name = "\"statutActif\"", nullable = false)
    private Boolean statutActif = true;
}
