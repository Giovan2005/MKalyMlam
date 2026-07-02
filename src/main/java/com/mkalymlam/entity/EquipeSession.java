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
@Table(name = "\"equipeSession\"")
public class EquipeSession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idEquipeSession\"")
    private Long idEquipeSession;

    @ManyToOne
    @JoinColumn(name = "\"idSession\"")
    private SessionTruck sessionTruck;

    @ManyToOne
    @JoinColumn(name = "\"idUtilisateur\"")
    private Utilisateur utilisateur;

    @ManyToOne
    @JoinColumn(name = "\"idRoleDuJour\"")
    private Role roleDuJour;

    @Column(name = "\"salaireJournalierRemplacant\"")
    private Double salaireJournalierRemplacant;

    public EquipeSession() {
    }

    public Long getIdEquipeSession() {
        return idEquipeSession;
    }

    public void setIdEquipeSession(Long idEquipeSession) {
        this.idEquipeSession = idEquipeSession;
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
