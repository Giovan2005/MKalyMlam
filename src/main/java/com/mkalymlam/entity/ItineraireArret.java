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
@Table(name = "\"itineraireArret\"")
public class ItineraireArret {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idArret\"")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "\"idItineraire\"")
    private Itineraire itineraire;

    @ManyToOne
    @JoinColumn(name = "\"idPointDeVente\"")
    private PointDeVente pointDeVente;

    @Column(name = "\"ordre\"")
    private Integer ordre;

    public ItineraireArret() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Itineraire getItineraire() { return itineraire; }
    public void setItineraire(Itineraire itineraire) { this.itineraire = itineraire; }
    public PointDeVente getPointDeVente() { return pointDeVente; }
    public void setPointDeVente(PointDeVente pointDeVente) { this.pointDeVente = pointDeVente; }
    public Integer getOrdre() { return ordre; }
    public void setOrdre(Integer ordre) { this.ordre = ordre; }
}
