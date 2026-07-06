package com.mkalymlam.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.mkalymlam.entity.DemandeChangementItineraire;
import com.mkalymlam.entity.SessionTruck;
import com.mkalymlam.repository.DemandeChangementItineraireRepository;

@Service
public class DemandeChangementItineraireService {

    private final DemandeChangementItineraireRepository repository;
    private final StatutValidationService statutValidationService;
    private final SessionTruckService sessionTruckService;


    public DemandeChangementItineraireService( DemandeChangementItineraireRepository repository, StatutValidationService statutValidationService, SessionTruckService sessionTruckService) {

        this.repository = repository;
        this.statutValidationService = statutValidationService;
        this.sessionTruckService = sessionTruckService;
    }


    public DemandeChangementItineraire demanderChangementItineraire(DemandeChangementItineraire DemandeChangementItineraire) {
        return repository.save(DemandeChangementItineraire);
    }
    
    public List<DemandeChangementItineraire> findAll() {
        return repository.findAll();
    }

    public DemandeChangementItineraire getById(Long id) {
        return repository.findById(id).orElse(null);
    }


    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public void valider(Long id) {
        DemandeChangementItineraire demande = repository.findById(id).orElse(null);

        if (demande != null) {
            demande.setStatutValidation(
                    statutValidationService.findByLibelle("VALIDE")
            );

            SessionTruck sessionTruck = demande.getSessionTruck();
            sessionTruck.setItineraire(demande.getItinerairePropose());
            sessionTruckService.save(sessionTruck);
            
            repository.save(demande);
        }




    }

    public void refuser(Long id) {

        DemandeChangementItineraire demande = repository.findById(id).orElse(null);

        if (demande != null) {

            demande.setStatutValidation(
                    statutValidationService.findByLibelle("REFUSE")
            );

            repository.save(demande);
        }

    }
}