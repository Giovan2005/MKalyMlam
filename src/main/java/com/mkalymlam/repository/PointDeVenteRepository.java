package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.PointDeVente;

@Repository
public interface PointDeVenteRepository extends JpaRepository<PointDeVente, Long> {

}
