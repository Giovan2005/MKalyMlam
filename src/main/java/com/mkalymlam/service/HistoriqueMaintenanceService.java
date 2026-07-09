package com.mkalymlam.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.HistoriqueMaintenance;
import com.mkalymlam.entity.Truck;
import com.mkalymlam.repository.HistoriqueMaintenanceRepository;
import com.mkalymlam.repository.TruckRepository;

@Service
public class HistoriqueMaintenanceService {

    private final HistoriqueMaintenanceRepository historiqueMaintenanceRepository;
    private final TruckRepository truckRepository;

    public HistoriqueMaintenanceService(HistoriqueMaintenanceRepository historiqueMaintenanceRepository,
                                        TruckRepository truckRepository) {
        this.historiqueMaintenanceRepository = historiqueMaintenanceRepository;
        this.truckRepository = truckRepository;
    }

    @Transactional
    public HistoriqueMaintenance save(Long truckId, LocalDate dateDebut, String description) {
        Truck truck = findTruck(truckId);
        HistoriqueMaintenance m = new HistoriqueMaintenance();
        m.setTruck(truck);
        m.setDateDebut(dateDebut);
        m.setDescription(description);
        return historiqueMaintenanceRepository.save(m);
    }

    @Transactional
    public HistoriqueMaintenance update(Long id, Long truckId, LocalDate dateDebut,
                                         LocalDate dateFin, String description) {
        HistoriqueMaintenance m = find(id);
        if (truckId != null) {
            m.setTruck(findTruck(truckId));
        }
        if (dateDebut != null) {
            m.setDateDebut(dateDebut);
        }
        if (dateFin != null) {
            m.setDateFin(dateFin);
        }
        if (description != null && !description.isBlank()) {
            m.setDescription(description);
        }
        return historiqueMaintenanceRepository.save(m);
    }

    @Transactional
    public HistoriqueMaintenance cloturer(Long id) {
        HistoriqueMaintenance m = find(id);
        m.setDateFin(LocalDate.now());
        return historiqueMaintenanceRepository.save(m);
    }

    public HistoriqueMaintenance find(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id maintenance null");
        }
        if (!historiqueMaintenanceRepository.existsById(id)) {
            throw new IllegalArgumentException("Maintenance " + id + " introuvable");
        }
        return historiqueMaintenanceRepository.findById(id).orElse(null);
    }

    public List<HistoriqueMaintenance> findAll() {
        return historiqueMaintenanceRepository.findAll();
    }

    @Transactional
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id maintenance null");
        }
        if (!historiqueMaintenanceRepository.existsById(id)) {
            throw new IllegalArgumentException("Maintenance " + id + " introuvable");
        }
        historiqueMaintenanceRepository.deleteById(id);
    }

    private Truck findTruck(Long truckId) {
        if (truckId == null) {
            throw new IllegalArgumentException("Id truck null");
        }
        if (!truckRepository.existsById(truckId)) {
            throw new IllegalArgumentException("Truck " + truckId + " introuvable");
        }
        return truckRepository.findById(truckId).orElse(null);
    }
}
