package com.mkalymlam.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.EquipeSession;
import com.mkalymlam.entity.EquipeSessionId;
import com.mkalymlam.entity.Role;
import com.mkalymlam.entity.SessionTruck;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.repository.EquipeSessionRepository;
import com.mkalymlam.repository.RoleRepository;
import com.mkalymlam.repository.SessionTruckRepository;
import com.mkalymlam.repository.UtilisateurRepository;

@Service
public class EquipeSessionService {

    private static final String ROLE_REMPLACANT = "REMPLACANT";

    private final EquipeSessionRepository equipeSessionRepository;
    private final SessionTruckRepository sessionTruckRepository;
    private final UtilisateurRepository utilisateurRepository;
    private final RoleRepository roleRepository;

    public EquipeSessionService(EquipeSessionRepository equipeSessionRepository,
                                SessionTruckRepository sessionTruckRepository,
                                UtilisateurRepository utilisateurRepository,
                                RoleRepository roleRepository) {
        this.equipeSessionRepository = equipeSessionRepository;
        this.sessionTruckRepository = sessionTruckRepository;
        this.utilisateurRepository = utilisateurRepository;
        this.roleRepository = roleRepository;
    }

    @Transactional
    public EquipeSession affecter(Long idSession, Long idUtilisateur, Long idRoleDuJour, Double salaireRemplacant) {
        SessionTruck session = sessionTruckRepository.findById(idSession)
                .orElseThrow(() -> new IllegalArgumentException("Session introuvable avec l'id " + idSession));

        Utilisateur utilisateur = utilisateurRepository.findById(idUtilisateur.intValue())
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur introuvable avec l'id " + idUtilisateur));

        // if (utilisateur.getIdRole() != null && ROLE_REMPLACANT.equals(utilisateur.getRole().getLibelle())) {
        //     if (salaireRemplacant == null || salaireRemplacant <= 0) {
        //         throw new IllegalArgumentException("Le salaire journalier remplacant est obligatoire pour un employe remplacant");
        //     }
        // }

        EquipeSessionId id = new EquipeSessionId(idSession, idUtilisateur);
        if (equipeSessionRepository.existsById(id)) {
            throw new IllegalArgumentException("Cet employe est deja affecte a cette session");
        }

        Role roleDuJour = roleRepository.findById(idRoleDuJour)
                .orElseThrow(() -> new IllegalArgumentException("RoleDuJour invalide : " + idRoleDuJour));

        EquipeSession equipeSession = new EquipeSession();
        equipeSession.setId(id);
        equipeSession.setSessionTruck(session);
        equipeSession.setUtilisateur(utilisateur);
        equipeSession.setRoleDuJour(roleDuJour);
        equipeSession.setSalaireJournalierRemplacant(salaireRemplacant);

        return equipeSessionRepository.save(equipeSession);
    }

    @Transactional
    public void affecterPlusieurs(Long idSession, List<Long> idUtilisateurs, List<Long> rolesDuJour, List<Double> salairesRemplacants) {
        List<String> erreurs = new java.util.ArrayList<>();
        for (int i = 0; i < idUtilisateurs.size(); i++) {
            Long idUtilisateur = idUtilisateurs.get(i);
            if (idUtilisateur == null || idUtilisateur == 0) {
                continue;
            }
            try {
                Double salaire = (salairesRemplacants != null && i < salairesRemplacants.size()) ? salairesRemplacants.get(i) : null;
                affecter(idSession, idUtilisateur, rolesDuJour.get(i), salaire);
            } catch (Exception e) {
                erreurs.add(e.getMessage());
            }
        }
        if (!erreurs.isEmpty()) {
            throw new IllegalArgumentException(String.join("; ", erreurs));
        }
    }

    @Transactional
    public void retirer(Long idSession, Long idUtilisateur) {
        EquipeSessionId id = new EquipeSessionId(idSession, idUtilisateur);
        if (!equipeSessionRepository.existsById(id)) {
            throw new IllegalArgumentException("Affectation introuvable pour cette session et cet utilisateur");
        }
        equipeSessionRepository.deleteById(id);
    }

    public List<EquipeSession> getEquipeSessionsBySessionTruckId(Long sessionTruckId) {
        return equipeSessionRepository.findBySessionTruck_Id(sessionTruckId);
    }

    public List<EquipeSession> getAllEquipeSessions() {
        return equipeSessionRepository.findAll();
    }

    public List<EquipeSession> getFilteredEquipeSessions(Long sessionId, Long roleId, String nomEmploye, LocalDate dateSession) {
        if (sessionId == null && roleId == null && nomEmploye == null && dateSession == null) {
            return getAllEquipeSessions();
        }
        return equipeSessionRepository.findByFilters(sessionId, roleId, nomEmploye, dateSession);
    }
}
