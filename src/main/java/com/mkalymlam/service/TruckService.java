package com.mkalymlam.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.StatutDisponibilite;
import com.mkalymlam.entity.Truck;
import com.mkalymlam.repository.StatutDisponibiliteRepository;
import com.mkalymlam.repository.TruckRepository;

@Service
public class TruckService {

    private static final String STATUT_DISPONIBLE = "DISPONIBLE";

    private final TruckRepository truckRepository;
    private final StatutDisponibiliteRepository statutDisponibiliteRepository;

    public TruckService(TruckRepository truckRepository,
                        StatutDisponibiliteRepository statutDisponibiliteRepository) {
        this.truckRepository = truckRepository;
        this.statutDisponibiliteRepository = statutDisponibiliteRepository;
    }

    @Transactional
    public Truck save(String immatriculation, String statut) {
        Truck truck = new Truck();
        truck.setImmatriculation(immatriculation);
        truck.setStatutDisponibilite(findStatut(normalizeStatut(statut)));
        return truckRepository.save(truck);
    }

    @Transactional
    public Truck update(Long id, String immatriculation, String statut) {
        Truck truck = find(id);

        if (immatriculation != null && !immatriculation.isBlank()) {
            truck.setImmatriculation(immatriculation);
        }
        if (statut != null && !statut.isBlank()) {
            truck.setStatutDisponibilite(findStatut(normalizeStatut(statut)));
        }

        return truckRepository.save(truck);
    }

    public Truck find(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id truck null");
        }
        if (!truckRepository.existsById(id)) {
            throw new IllegalArgumentException("Truck " + id + " introuvable");
        }
        return truckRepository.findById(id).orElse(null);
    }

    public List<Truck> findAll() {
        return truckRepository.findAll();
    }

    public List<Truck> findDisponibles() {
        return truckRepository.findByStatutDisponibilite(findStatut(STATUT_DISPONIBLE));
    }

    @Transactional
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id truck null");
        }
        if (!truckRepository.existsById(id)) {
            throw new IllegalArgumentException("Truck " + id + " introuvable");
        }
        truckRepository.deleteById(id);
    }

    public StatutDisponibilite findStatut(String libelle) {
        StatutDisponibilite statut = statutDisponibiliteRepository.findByLibelle(libelle);
        if (statut == null) {
            throw new IllegalArgumentException("Statut truck " + libelle + " introuvable");
        }
        return statut;
    }

    public String normalizeStatut(String statut) {
        if (statut == null || statut.isBlank()) {
            return STATUT_DISPONIBLE;
        }

        String value = statut.trim().toUpperCase();
        if ("EN_REPARATION".equals(value)) {
            return "EN_MAINTENANCE";
        }
        if ("EN_PANNE".equals(value)) {
            return "PANNE";
        }
        return value;
    }
}
