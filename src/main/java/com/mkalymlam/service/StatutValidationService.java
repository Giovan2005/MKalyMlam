package com.mkalymlam.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.mkalymlam.entity.StatutValidation;
import com.mkalymlam.repository.StatutValidationRepository;

@Service
public class StatutValidationService {

    private final StatutValidationRepository repository;

    public StatutValidationService(StatutValidationRepository repository) {
        this.repository = repository;
    }

    public List<StatutValidation> findAll() {
        return repository.findAll();
    }

    public StatutValidation findByLibelle(String libelle) {
        return repository.findByLibelle(libelle);
    }

}