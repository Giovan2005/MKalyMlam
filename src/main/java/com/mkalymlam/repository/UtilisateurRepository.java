package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mkalymlam.entity.Utilisateur;

import java.util.Optional;

public interface UtilisateurRepository extends JpaRepository<Utilisateur, Integer> {
    Optional<Utilisateur> findByEmail(String email);
    boolean existsByEmail(String email);
}