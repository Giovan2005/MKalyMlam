package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.TypeNotification;

@Repository
public interface TypeNotificationRepository extends JpaRepository<TypeNotification, Long> {

    TypeNotification findByLibelle(String libelle);
}
