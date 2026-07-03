package com.mkalymlam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.RetourClient;

@Repository
public interface RetourClientRepository extends JpaRepository<RetourClient, Long> {

    List<RetourClient> findByEstPopulaireTrue();

    List<RetourClient> findByContenuTexteIgnoreCase(String contenuTexte);

    List<RetourClient> findByIdTypeRetour(Long idTypeRetour);
}
