package com.mkalymlam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.HistoriqueStatus;
import com.mkalymlam.entity.StatutDisponibilite;
import com.mkalymlam.entity.Truck;

@Repository
public interface HistoriqueStatusRepository extends JpaRepository<HistoriqueStatus, Long> {

    List<HistoriqueStatus> findByTruckOrderByDateChangementDesc(Truck truck);

    List<HistoriqueStatus> findByStatutDisponibiliteOrderByDateChangementDesc(StatutDisponibilite statutDisponibilite);

    List<HistoriqueStatus> findByTruckAndStatutDisponibiliteOrderByDateChangementDesc(Truck truck, StatutDisponibilite statutDisponibilite);
}
