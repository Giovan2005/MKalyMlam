package com.mkalymlam.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.mkalymlam.entity.ActionAmelioration;
import com.mkalymlam.entity.StatutDemandeAchat;
import com.mkalymlam.repository.ActionAmeliorationRepository;

@Service
public class ActionAmeliorationService {

    private final ActionAmeliorationRepository repository;

    public ActionAmeliorationService(ActionAmeliorationRepository repository) {
        this.repository = repository;
    }

    public ActionAmelioration save(ActionAmelioration action) {
        if (action.getStatutDemandeAchat() == null) {
            action.setStatutDemandeAchat(StatutDemandeAchat.NON_APPLICABLE);
        }
        action.setDateCreation(LocalDateTime.now());
        return repository.save(action);
    }

    public ActionAmelioration update(Long idAction, StatutDemandeAchat nouveauStatut) {
        ActionAmelioration action = repository.findById(idAction)
                .orElseThrow(() -> new RuntimeException("Action introuvable avec id : " + idAction));
        action.setStatutDemandeAchat(nouveauStatut);
        return repository.save(action);
    }

    public List<ActionAmelioration> findAll() {
        return repository.findAll();
    }

    public List<ActionAmelioration> findByRetour(Long idRetour) {
        return repository.findByRetourClient_IdRetour(idRetour);
    }
}