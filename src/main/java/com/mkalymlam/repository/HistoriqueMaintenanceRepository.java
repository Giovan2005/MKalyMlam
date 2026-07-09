package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.HistoriqueMaintenance;

@Repository
public interface HistoriqueMaintenanceRepository extends JpaRepository<HistoriqueMaintenance, Long> {
}
