package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.StatutDisponibilite;

@Repository
public interface StatutDisponibiliteRepository extends JpaRepository<StatutDisponibilite, Long> {

    StatutDisponibilite findByLibelle(String libelle);
}
