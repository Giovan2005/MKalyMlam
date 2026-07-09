package com.mkalymlam.service;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.mkalymlam.entity.HistoriqueStatus;
import com.mkalymlam.entity.StatutDisponibilite;
import com.mkalymlam.entity.Truck;
import com.mkalymlam.repository.HistoriqueStatusRepository;

@Service
public class HistoriqueStatusService {

    private final HistoriqueStatusRepository historiqueStatusRepository;

    public HistoriqueStatusService(HistoriqueStatusRepository historiqueStatusRepository) {
        this.historiqueStatusRepository = historiqueStatusRepository;
    }

    public List<HistoriqueStatus> findAll() {
        return historiqueStatusRepository.findAll(Sort.by(Sort.Direction.DESC, "dateChangement"));
    }

    public List<HistoriqueStatus> findByTruck(Truck truck) {
        return historiqueStatusRepository.findByTruckOrderByDateChangementDesc(truck);
    }

    public List<HistoriqueStatus> findByStatut(StatutDisponibilite statut) {
        return historiqueStatusRepository.findByStatutDisponibiliteOrderByDateChangementDesc(statut);
    }

    public List<HistoriqueStatus> findByTruckAndStatut(Truck truck, StatutDisponibilite statut) {
        return historiqueStatusRepository.findByTruckAndStatutDisponibiliteOrderByDateChangementDesc(truck, statut);
    }
}
