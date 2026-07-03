package com.mkalymlam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.EquipeSession;
import com.mkalymlam.entity.SessionTruck;

@Repository
public interface EquipeSessionRepository extends JpaRepository<EquipeSession, Long> {

    List<EquipeSession> findBySessionTruck(SessionTruck sessionTruck);
}
