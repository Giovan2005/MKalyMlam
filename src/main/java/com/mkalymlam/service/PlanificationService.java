package com.mkalymlam.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.Itineraire;
import com.mkalymlam.entity.ItineraireArret;
import com.mkalymlam.entity.PointDeVente;
import com.mkalymlam.repository.ItineraireArretRepository;
import com.mkalymlam.repository.ItineraireRepository;

@Service
public class PlanificationService {

    private final ItineraireRepository itineraireRepository;
    private final ItineraireArretRepository arretRepository;

    public PlanificationService(ItineraireRepository itineraireRepository,
                                ItineraireArretRepository arretRepository) {
        this.itineraireRepository = itineraireRepository;
        this.arretRepository = arretRepository;
    }

    @Transactional
    public ItineraireArret ajouterArret(Long idItineraire, Long idPointDeVente, Integer ordre) {
        Itineraire itineraire = itineraireRepository.findById(idItineraire)
                .orElseThrow(() -> new IllegalArgumentException("Itinéraire " + idItineraire + " introuvable"));

        PointDeVente pdv = new PointDeVente();
        pdv.setId(idPointDeVente);

        ItineraireArret arret = new ItineraireArret();
        arret.setItineraire(itineraire);
        arret.setPointDeVente(pdv);
        arret.setOrdre(ordre);

        return arretRepository.save(arret);
    }

    public List<ItineraireArret> getArretsByItineraire(Long idItineraire) {
        return arretRepository.findByItineraire_IdOrderByOrdreAsc(idItineraire);
    }

    @Transactional
    public void supprimerArret(Long idArret) {
        if (idArret == null || !arretRepository.existsById(idArret)) {
            throw new IllegalArgumentException("Arrêt " + idArret + " introuvable");
        }
        arretRepository.deleteById(idArret);
    }

    @Transactional
    public void supprimerTousLesArrets(Long idItineraire) {
        arretRepository.deleteByItineraire_Id(idItineraire);
    }

    public Itineraire getItineraire(Long id) {
        return itineraireRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Itinéraire " + id + " introuvable"));
    }

    public List<Itineraire> getAllItineraires() {
        return itineraireRepository.findAll();
    }

    @Transactional
    public void enregistrerArrets(Long idItineraire, List<Long> idsPointsDeVente) {
        supprimerTousLesArrets(idItineraire);
        for (int i = 0; i < idsPointsDeVente.size(); i++) {
            ajouterArret(idItineraire, idsPointsDeVente.get(i), i + 1);
        }
    }
}
