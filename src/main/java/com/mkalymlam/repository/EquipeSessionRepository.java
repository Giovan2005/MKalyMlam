package com.mkalymlam.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.EquipeSession;
import com.mkalymlam.entity.EquipeSessionId;
import com.mkalymlam.entity.SessionTruck;

@Repository
public interface EquipeSessionRepository extends JpaRepository<EquipeSession, EquipeSessionId> {

    List<EquipeSession> findBySessionTruck(SessionTruck sessionTruck);

    List<EquipeSession> findBySessionTruck_Id(Long sessionTruckId);

    void deleteBySessionTruck_IdAndUtilisateur_Id(Long sessionTruckId, Long utilisateurId);

    @Query("SELECT es FROM EquipeSession es WHERE "
            + "(:sessionId IS NULL OR es.sessionTruck.id = :sessionId) "
            + "AND (:roleId IS NULL OR es.roleDuJour.id = :roleId) "
            + "AND (:nomEmploye IS NULL OR LOWER(es.utilisateur.nom) LIKE LOWER(CONCAT(:nomEmploye, '%')) OR LOWER(es.utilisateur.prenom) LIKE LOWER(CONCAT(:nomEmploye, '%'))) "
            + "AND (:dateSession IS NULL OR es.sessionTruck.dateSession = :dateSession)")
    List<EquipeSession> findByFilters(@Param("sessionId") Long sessionId,
                                      @Param("roleId") Long roleId,
                                      @Param("nomEmploye") String nomEmploye,
                                      @Param("dateSession") LocalDate dateSession);
}
