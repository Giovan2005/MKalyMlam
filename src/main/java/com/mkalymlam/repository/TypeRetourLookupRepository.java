package com.mkalymlam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.TypeRetourLookup;

@Repository
public interface TypeRetourLookupRepository extends JpaRepository<TypeRetourLookup, Long> {

    List<TypeRetourLookup> findByLibelle(String libelle);
}
