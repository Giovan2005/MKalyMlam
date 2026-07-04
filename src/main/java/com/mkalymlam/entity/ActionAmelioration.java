package com.mkalymlam.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "\"actionAmelioration\"")
public class ActionAmelioration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idAction\"")
    private Long idAction;

    @ManyToOne
    @JoinColumn(name = "\"idRetourOrigine\"")
    private RetourClient retourClient;

    @ManyToOne
    @JoinColumn(name = "\"idAuteurAdmin\"")
    private Utilisateur auteurAdmin;

    @Column(name = "\"instructionEmployes\"", nullable = false)
    private String instructionEmployes;

    @Enumerated(EnumType.STRING)
    @Column(name = "\"statutDemandeAchat\"")
    private StatutDemandeAchat statutDemandeAchat;

    @Column(name = "\"dateCreation\"")
    private LocalDateTime dateCreation;

    public ActionAmelioration() {
    }

    public Long getIdAction() {
        return idAction;
    }

    public void setIdAction(Long idAction) {
        this.idAction = idAction;
    }

    public RetourClient getRetourClient() {
        return retourClient;
    }

    public void setRetourClient(RetourClient retourClient) {
        this.retourClient = retourClient;
    }

    public Utilisateur getAuteurAdmin() {
        return auteurAdmin;
    }

    public void setAuteurAdmin(Utilisateur auteurAdmin) {
        this.auteurAdmin = auteurAdmin;
    }

    public String getInstructionEmployes() {
        return instructionEmployes;
    }

    public void setInstructionEmployes(String instructionEmployes) {
        this.instructionEmployes = instructionEmployes;
    }

    public StatutDemandeAchat getStatutDemandeAchat() {
        return statutDemandeAchat;
    }

    public void setStatutDemandeAchat(StatutDemandeAchat statutDemandeAchat) {
        this.statutDemandeAchat = statutDemandeAchat;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }
}