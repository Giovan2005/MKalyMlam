package com.mkalymlam.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.Notification;
import com.mkalymlam.entity.Produit;
import com.mkalymlam.entity.SessionTruck;
import com.mkalymlam.entity.TypeNotification;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {

    List<Notification> findAllByOrderByDateHeureEnvoiDesc();

    List<Notification> findByTypeNotificationOrderByDateHeureEnvoiDesc(TypeNotification typeNotification);

    List<Notification> findByProduitLieOrderByDateHeureEnvoiDesc(Produit produitLie);

    List<Notification> findBySessionLieeOrderByDateHeureEnvoiDesc(SessionTruck sessionLiee);

    List<Notification> findByDateHeureEnvoiGreaterThanEqualOrderByDateHeureEnvoiDesc(LocalDateTime depuis);

    List<Notification> findByDateHeureEnvoiLessThanOrderByDateHeureEnvoiDesc(LocalDateTime avant);
}
