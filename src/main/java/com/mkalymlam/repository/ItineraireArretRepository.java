package com.mkalymlam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.Itineraire;
import com.mkalymlam.entity.ItineraireArret;

@Repository
public interface ItineraireArretRepository extends JpaRepository<ItineraireArret, Long> {

    List<ItineraireArret> findByItineraireOrderByOrdreAsc(Itineraire itineraire);

    List<ItineraireArret> findByItineraire_IdOrderByOrdreAsc(Long idItineraire);

    void deleteByItineraire_Id(Long idItineraire);
}
