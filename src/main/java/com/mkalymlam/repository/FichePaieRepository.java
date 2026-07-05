package com.mkalymlam.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mkalymlam.entity.FichePaie;

public interface FichePaieRepository extends JpaRepository<FichePaie, Long> {

    java.util.List<FichePaie> findByUtilisateur_Id(Long idUtilisateur);

    java.util.List<FichePaie> findByMoisAnnee(String moisAnnee);

    Optional<FichePaie> findByUtilisateur_IdAndMoisAnnee(Long idUtilisateur, String moisAnnee);
}