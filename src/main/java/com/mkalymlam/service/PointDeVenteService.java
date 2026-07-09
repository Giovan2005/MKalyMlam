package com.mkalymlam.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.PointDeVente;
import com.mkalymlam.repository.PointDeVenteRepository;

@Service
public class PointDeVenteService {

    private final PointDeVenteRepository repository;

    public PointDeVenteService(PointDeVenteRepository repository) {
        this.repository = repository;
    }

    @Transactional
    public PointDeVente save(PointDeVente pointDeVente) {
        return repository.save(pointDeVente);
    }

    public List<PointDeVente> findAll() {
        return repository.findAll();
    }

    public List<PointDeVente> findAllActifs() {
        return repository.findAll().stream()
                .filter(p -> p.getEstActif() != null && p.getEstActif())
                .toList();
    }

    public PointDeVente find(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("PointDeVente " + id + " introuvable"));
    }

    @Transactional
    public PointDeVente update(PointDeVente pointDeVente) {
        if (pointDeVente == null || pointDeVente.getId() == null) {
            throw new IllegalArgumentException("Point de vente invalide");
        }
        if (!repository.existsById(pointDeVente.getId())) {
            throw new IllegalArgumentException("PointDeVente " + pointDeVente.getId() + " introuvable");
        }
        return repository.save(pointDeVente);
    }

    @Transactional
    public void delete(Long id) {
        if (id == null || !repository.existsById(id)) {
            throw new IllegalArgumentException("PointDeVente " + id + " introuvable");
        }
        repository.deleteById(id);
    }
}
