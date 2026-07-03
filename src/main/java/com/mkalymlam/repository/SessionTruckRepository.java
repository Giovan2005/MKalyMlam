package com.mkalymlam.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.SessionTruck;
import com.mkalymlam.entity.StatutSession;
import com.mkalymlam.entity.Truck;

@Repository
public interface SessionTruckRepository extends JpaRepository<SessionTruck, Long> {

    List<SessionTruck> findByDateSession(LocalDate dateSession);

    boolean existsByTruckAndStatutSession(Truck truck, StatutSession statutSession);
}
