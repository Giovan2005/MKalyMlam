package com.mkalymlam.service;

import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.repository.UtilisateurRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class EmployeService {

    private final UtilisateurRepository utilisateurRepository;

    public EmployeService(UtilisateurRepository utilisateurRepository) {
        this.utilisateurRepository = utilisateurRepository;
    }

    public List<Utilisateur> findAll() {
        return utilisateurRepository.findAll();
    }

    public Optional<Utilisateur> findById(Integer id) {
        return utilisateurRepository.findById(id);
    }

    public void toggleStatus(Integer id) {
        Utilisateur user = utilisateurRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Employé introuvable"));
        user.setStatutActif(!user.getStatutActif());
        utilisateurRepository.save(user);
    }

    // Mapping idRole → libellé (basé sur vos insertions)
    public String getRoleLibelle(int idRole) {
        return switch (idRole) {
            case 1 -> "Admin";
            case 2 -> "Vendeuse";
            case 3 -> "Cuisinier";
            case 4 -> "Chauffeur";
            case 5 -> "Remplaçant";
            default -> "Inconnu";
        };
    }
}