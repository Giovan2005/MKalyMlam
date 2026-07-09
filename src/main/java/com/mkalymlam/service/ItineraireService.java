package com.mkalymlam.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mkalymlam.entity.Itineraire;
import com.mkalymlam.repository.ItineraireRepository;
import jakarta.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
@Service
public class ItineraireService {
    
    private final ItineraireRepository itineraireRepository;

    public ItineraireService(ItineraireRepository itineraireRepository) {
        this.itineraireRepository = itineraireRepository;
    }

    @Transactional
    public Itineraire save(Itineraire itineraire) {
        return itineraireRepository.save(itineraire);
    }

    public List<Itineraire> findAll() {
        return itineraireRepository.findAll();
    }

    public List<Itineraire> search(String nomZone, String jourSemaine, String lieuExact) {
        return itineraireRepository.findAll((root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (nomZone != null && !nomZone.isBlank()) {
                predicates.add(cb.like(cb.lower(root.get("nomZone")),
                                       "%" + nomZone.toLowerCase() + "%"));
            }
            if (jourSemaine != null && !jourSemaine.isBlank()) {
                predicates.add(cb.equal(root.get("jourSemaine"), jourSemaine));
            }
            if (lieuExact != null && !lieuExact.isBlank()) {
                predicates.add(cb.like(cb.lower(root.get("lieuExact")),
                                       "%" + lieuExact.toLowerCase() + "%"));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        });
    }

    public Itineraire find(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id null");
        }
        if (!itineraireRepository.existsById(id)) {
            throw new IllegalArgumentException("Itineraire" + id + " does not exist");
        }
        return itineraireRepository.findById(id).orElse(null);
    }

    @Transactional
    public Itineraire update(Itineraire itineraire) {
        if (itineraire == null || itineraire.getId() == null) {
            throw new IllegalArgumentException(
                "Pas de itineraire");
        }
        if (!itineraireRepository.existsById(itineraire.getId())) {
            throw new IllegalArgumentException(
                "pas de l'" + itineraire.getId() + " dans la base ");
        }
        return itineraireRepository.save(itineraire);
    }

    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id null");
        }
        if (!itineraireRepository.existsById(id)) {
            throw new IllegalArgumentException("Itineraire" + id + " does not exist");
        }
        itineraireRepository.deleteById(id);
    }

    
}


