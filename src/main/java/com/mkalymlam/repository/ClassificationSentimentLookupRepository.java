package com.mkalymlam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.ClassificationSentimentLookup;

@Repository
public interface ClassificationSentimentLookupRepository extends JpaRepository<ClassificationSentimentLookup, Long> {

    List<ClassificationSentimentLookup> findByLibelle(String libelle);
}
