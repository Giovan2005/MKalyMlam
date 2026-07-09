package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.Itineraire;

@Repository
public interface ItineraireRepository extends JpaRepository<Itineraire, Long>,
                                               JpaSpecificationExecutor<Itineraire> {

}