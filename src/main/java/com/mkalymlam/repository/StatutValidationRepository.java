package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.StatutValidation;

@Repository
public interface StatutValidationRepository extends JpaRepository<StatutValidation, Long> {

    StatutValidation findByLibelle(String libelle);

}
