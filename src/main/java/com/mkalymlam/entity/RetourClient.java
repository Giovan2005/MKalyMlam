package com.mkalymlam.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "\"retourClient\"")
public class RetourClient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idRetour\"")
    private Long idRetour;

    @Column(name = "\"idTypeRetour\"")
    private Long idTypeRetour;

    @Transient
    private TypeRetour typeRetour;

    @Column(name = "\"noteSur10\"")
    private Integer noteSur10;

    @Column(name = "\"contenuTexte\"", nullable = false)
    private String contenuTexte;

    @Column(name = "\"idClassificationSentiment\"")
    private Long idClassificationSentiment;

    @Transient
    private ClassificationSentiment classificationSentiment;

    @Column(name = "\"estPopulaire\"")
    private Boolean estPopulaire = false;

    @Column(name = "\"dateSoumission\"")
    private LocalDateTime dateSoumission;

    public RetourClient() {
    }

    public Long getIdRetour() {
        return idRetour;
    }

    public void setIdRetour(Long idRetour) {
        this.idRetour = idRetour;
    }

    public Long getIdTypeRetour() {
        return idTypeRetour;
    }

    public void setIdTypeRetour(Long idTypeRetour) {
        this.idTypeRetour = idTypeRetour;
    }

    public TypeRetour getTypeRetour() {
        return typeRetour;
    }

    public void setTypeRetour(TypeRetour typeRetour) {
        this.typeRetour = typeRetour;
    }

    public Integer getNoteSur10() {
        return noteSur10;
    }

    public void setNoteSur10(Integer noteSur10) {
        this.noteSur10 = noteSur10;
    }

    public String getContenuTexte() {
        return contenuTexte;
    }

    public void setContenuTexte(String contenuTexte) {
        this.contenuTexte = contenuTexte;
    }

    public Long getIdClassificationSentiment() {
        return idClassificationSentiment;
    }

    public void setIdClassificationSentiment(Long idClassificationSentiment) {
        this.idClassificationSentiment = idClassificationSentiment;
    }

    public ClassificationSentiment getClassificationSentiment() {
        return classificationSentiment;
    }

    public void setClassificationSentiment(ClassificationSentiment classificationSentiment) {
        this.classificationSentiment = classificationSentiment;
    }

    public Boolean getEstPopulaire() {
        return estPopulaire;
    }

    public void setEstPopulaire(Boolean estPopulaire) {
        this.estPopulaire = estPopulaire;
    }

    public LocalDateTime getDateSoumission() {
        return dateSoumission;
    }

    public void setDateSoumission(LocalDateTime dateSoumission) {
        this.dateSoumission = dateSoumission;
    }
}
