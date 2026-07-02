package com.mkalymlam.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.Ingredient;
import com.mkalymlam.entity.LotIngredient;
import com.mkalymlam.repository.IngredientRepository;
import com.mkalymlam.repository.LotIngredientRepository;

@Service
public class LotIngredientService {

    private final LotIngredientRepository lotIngredientRepository;
    private final IngredientRepository ingredientRepository;

    public LotIngredientService(LotIngredientRepository lotIngredientRepository, IngredientRepository ingredientRepository) {
        this.lotIngredientRepository = lotIngredientRepository;
        this.ingredientRepository = ingredientRepository;
    }

    public List<LotIngredient> getAll() {
        return lotIngredientRepository.findAllByOrderByDateReceptionAsc();
    }

    public List<LotIngredient> findByIngredientId(Long ingredientId) {
        return lotIngredientRepository.findByIngredient_IdIngredient(ingredientId);
    }

    public List<LotIngredient> findByIngredientName(String nomIngredient) {
        return lotIngredientRepository.findByIngredient_NomIngredientContainingIgnoreCase(nomIngredient);
    }

    public LotIngredient getById(Long id) {
        return lotIngredientRepository.findById(id).orElse(null);
    }


    @Transactional
    public LotIngredient save(LotIngredient lotIngredient) {
        if (lotIngredient.getIngredient() != null && lotIngredient.getIngredient().getIdIngredient() != null) {
            Ingredient ingredient = ingredientRepository.findById(lotIngredient.getIngredient().getIdIngredient())
                    .orElse(null);
            lotIngredient.setIngredient(ingredient);
        }
        if (lotIngredient.getDateReception() == null) {
            lotIngredient.setDateReception(LocalDate.now());
        }
        if (lotIngredient.getQuantiteRestante() == null) {
            lotIngredient.setQuantiteRestante(lotIngredient.getQuantiteInitiale());
        }
        return lotIngredientRepository.save(lotIngredient);
    }


    @Transactional
    public LotIngredient update(Long id, LotIngredient lotIngredient) {
        LotIngredient existing = getById(id);
        if (existing == null) {
            return null;
        }

        if (lotIngredient.getIngredient() != null && lotIngredient.getIngredient().getIdIngredient() != null) {
            Ingredient ingredient = ingredientRepository.findById(lotIngredient.getIngredient().getIdIngredient())
                    .orElse(null);
            existing.setIngredient(ingredient);
        }
        if (lotIngredient.getDateReception() != null) {
            existing.setDateReception(lotIngredient.getDateReception());
        }
        if (lotIngredient.getDatePeremption() != null) {
            existing.setDatePeremption(lotIngredient.getDatePeremption());
        }
        if (lotIngredient.getQuantiteInitiale() != null) {
            existing.setQuantiteInitiale(lotIngredient.getQuantiteInitiale());
        }
        if (lotIngredient.getQuantiteRestante() != null) {
            existing.setQuantiteRestante(lotIngredient.getQuantiteRestante());
        }
        if (lotIngredient.getPrixAchatUnitaire() != null) {
            existing.setPrixAchatUnitaire(lotIngredient.getPrixAchatUnitaire());
        }

        return lotIngredientRepository.save(existing);
    }


    @Transactional
    public void deleteById(Long id) {
        lotIngredientRepository.deleteById(id);
    }

    public List<LotIngredient> getAlertLots() {
        return lotIngredientRepository.findAll().stream().filter(lot -> lot.getIngredient() != null  && lot.getIngredient().getSeuilAlerteQuantite() != null && lot.getQuantiteRestante() != null && lot.getQuantiteRestante() <= lot.getIngredient().getSeuilAlerteQuantite()) .toList();
    }

    public boolean verifierAlerte(LotIngredient lotIngredient) {
        if (lotIngredient.getIngredient() != null && lotIngredient.getQuantiteRestante() != null) {
            Double seuilAlerte = lotIngredient.getIngredient().getSeuilAlerteQuantite();
            if( seuilAlerte != null && lotIngredient.getQuantiteRestante() <= seuilAlerte){ 
                return true;
            }
        }
        return false;
    }

    public double quantiteLotIngredientActuelleByIngredient(Long idIngredient ){
        Double quantiteActuelle = lotIngredientRepository.sumQuantiteRestanteByIdIngredient(idIngredient);
        return quantiteActuelle != null ? quantiteActuelle : 0.0;
    }

    public List<LotIngredient> getAllWithAlertStatus() {
        List<LotIngredient> lots = lotIngredientRepository.findAll();
        lots.forEach(lot -> {
            lot.setAlerte(verifierAlerte(lot));
        });
        return lots;
    }

    public List<Ingredient> getAllIngredients() {
        return ingredientRepository.findAll();
    }
}
