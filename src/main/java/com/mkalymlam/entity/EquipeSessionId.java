package com.mkalymlam.entity;

import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class EquipeSessionId implements Serializable {

    private Long idSession;
    private Long idUtilisateur;

    public EquipeSessionId() {
    }

    public EquipeSessionId(Long idSession, Long idUtilisateur) {
        this.idSession = idSession;
        this.idUtilisateur = idUtilisateur;
    }

    public Long getIdSession() {
        return idSession;
    }

    public void setIdSession(Long idSession) {
        this.idSession = idSession;
    }

    public Long getIdUtilisateur() {
        return idUtilisateur;
    }

    public void setIdUtilisateur(Long idUtilisateur) {
        this.idUtilisateur = idUtilisateur;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        EquipeSessionId that = (EquipeSessionId) o;
        return Objects.equals(idSession, that.idSession) &&
               Objects.equals(idUtilisateur, that.idUtilisateur);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idSession, idUtilisateur);
    }
}
