package com.mkalymlam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mkalymlam.entity.ActionAmelioration;

public interface ActionAmeliorationRepository extends JpaRepository<ActionAmelioration, Long> {

    List<ActionAmelioration> findByRetourClient_IdRetour(Long idRetour);
}