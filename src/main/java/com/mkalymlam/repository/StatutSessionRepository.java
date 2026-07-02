package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.StatutSession;

@Repository
public interface StatutSessionRepository extends JpaRepository<StatutSession, Long> {

    StatutSession findByLibelle(String libelle);
}
