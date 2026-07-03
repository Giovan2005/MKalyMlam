package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.DemandeChangementItineraire;

@Repository
public interface DemandeChangementItineraireRepository extends JpaRepository<DemandeChangementItineraire, Long> {
}
