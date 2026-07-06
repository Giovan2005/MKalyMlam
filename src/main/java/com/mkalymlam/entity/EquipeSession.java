package com.mkalymlam.entity;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;

@Entity
@Table(name = "\"equipeSession\"")
public class EquipeSession {

    @EmbeddedId
    private EquipeSessionId id;

    @ManyToOne
    @MapsId("idSession")
    @JoinColumn(name = "\"idSession\"")
    private SessionTruck sessionTruck;

    @ManyToOne
    @MapsId("idUtilisateur")
    @JoinColumn(name = "\"idUtilisateur\"")
    private Utilisateur utilisateur;

    @ManyToOne
    @JoinColumn(name = "\"idRoleDuJour\"")
    private Role roleDuJour;

    @Column(name = "\"salaireJournalierRemplacant\"")
    private Double salaireJournalierRemplacant;

    public EquipeSession() {
    }

    public EquipeSessionId getId() {
        return id;
    }

    public void setId(EquipeSessionId id) {
        this.id = id;
    }

    public SessionTruck getSessionTruck() {
        return sessionTruck;
    }

    public void setSessionTruck(SessionTruck sessionTruck) {
        this.sessionTruck = sessionTruck;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }

    public Role getRoleDuJour() {
        return roleDuJour;
    }

    public void setRoleDuJour(Role roleDuJour) {
        this.roleDuJour = roleDuJour;
    }

    public Double getSalaireJournalierRemplacant() {
        return salaireJournalierRemplacant;
    }

    public void setSalaireJournalierRemplacant(Double salaireJournalierRemplacant) {
        this.salaireJournalierRemplacant = salaireJournalierRemplacant;
    }
}
