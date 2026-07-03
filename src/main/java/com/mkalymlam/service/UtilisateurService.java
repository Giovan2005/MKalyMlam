package com.mkalymlam.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.repository.UtilisateurRepository;

@Service
public class UtilisateurService {

    private final UtilisateurRepository repository;

    public UtilisateurService(UtilisateurRepository repository) {
        this.repository = repository;
    }

    public List<Utilisateur> findAll() {
        return repository.findAll();
    }

    public Utilisateur getById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public Utilisateur save(Utilisateur Utilisateur) {
        return repository.save(Utilisateur);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}