package com.mkalymlam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.StatutDisponibilite;
import com.mkalymlam.entity.Truck;

@Repository
public interface TruckRepository extends JpaRepository<Truck, Long> {

    List<Truck> findByStatutDisponibilite(StatutDisponibilite statutDisponibilite);
}
