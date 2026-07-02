package com.mkalymlam.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.EquipeSession;
import com.mkalymlam.entity.Itineraire;
import com.mkalymlam.entity.Role;
import com.mkalymlam.entity.SessionTruck;
import com.mkalymlam.entity.StatutSession;
import com.mkalymlam.entity.Truck;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.repository.EquipeSessionRepository;
import com.mkalymlam.repository.ItineraireRepository;
import com.mkalymlam.repository.RoleRepository;
import com.mkalymlam.repository.SessionTruckRepository;
import com.mkalymlam.repository.StatutSessionRepository;
import com.mkalymlam.repository.TruckRepository;
import com.mkalymlam.repository.UtilisateurRepository;

@Service
public class SessionTruckService {

    private static final String STATUT_DISPONIBLE = "DISPONIBLE";
    private static final String STATUT_OUVERTE = "OUVERTE";
    private static final String STATUT_CLOTUREE = "CLOTUREE";
    private static final String ROLE_CHAUFFEUR = "CHAUFFEUR";

    private final SessionTruckRepository sessionTruckRepository;
    private final TruckRepository truckRepository;
    private final ItineraireRepository itineraireRepository;
    private final StatutSessionRepository statutSessionRepository;
    private final UtilisateurRepository utilisateurRepository;
    private final RoleRepository roleRepository;
    private final EquipeSessionRepository equipeSessionRepository;

    public SessionTruckService(SessionTruckRepository sessionTruckRepository,
                               TruckRepository truckRepository,
                               ItineraireRepository itineraireRepository,
                               StatutSessionRepository statutSessionRepository,
                               UtilisateurRepository utilisateurRepository,
                               RoleRepository roleRepository,
                               EquipeSessionRepository equipeSessionRepository) {
        this.sessionTruckRepository = sessionTruckRepository;
        this.truckRepository = truckRepository;
        this.itineraireRepository = itineraireRepository;
        this.statutSessionRepository = statutSessionRepository;
        this.utilisateurRepository = utilisateurRepository;
        this.roleRepository = roleRepository;
        this.equipeSessionRepository = equipeSessionRepository;
    }

    @Transactional
    public SessionTruck ouvrir(Long idTruck,
                               Long idItineraire,
                               Long idChauffeur,
                               Double fondDeCaisseOuverture) {
        Truck truck = findTruck(idTruck);
        Itineraire itineraire = findItineraire(idItineraire);
        Utilisateur chauffeur = findUtilisateur(idChauffeur);
        StatutSession statutOuverte = findStatutSession(STATUT_OUVERTE);

        String statutTruck = truck.getStatutDisponibilite() != null
                ? truck.getStatutDisponibilite().getLibelle()
                : null;

        if (!STATUT_DISPONIBLE.equals(statutTruck)) {
            throw new IllegalArgumentException("Le truck doit etre DISPONIBLE pour ouvrir une session");
        }

        if (sessionTruckRepository.existsByTruckAndStatutSession(truck, statutOuverte)) {
            throw new IllegalArgumentException("Ce truck a deja une session ouverte");
        }

        SessionTruck sessionTruck = new SessionTruck();
        sessionTruck.setTruck(truck);
        sessionTruck.setItineraire(itineraire);
        sessionTruck.setDateSession(LocalDate.now());
        sessionTruck.setFondDeCaisseOuverture(fondDeCaisseOuverture);
        sessionTruck.setChiffreAffaireTotal(0.0);
        sessionTruck.setCommissionTotaleEquipe(0.0);
        sessionTruck.setStatutSession(statutOuverte);

        SessionTruck saved = sessionTruckRepository.save(sessionTruck);
        saveChauffeur(saved, chauffeur);

        return saved;
    }

    @Transactional
    public SessionTruck cloturer(Long idSession, Double fondDeCaisseCloture) {
        SessionTruck sessionTruck = find(idSession);
        StatutSession statutCloturee = findStatutSession(STATUT_CLOTUREE);

        if (sessionTruck.getStatutSession() == null
                || !STATUT_OUVERTE.equals(sessionTruck.getStatutSession().getLibelle())) {
            throw new IllegalArgumentException("La session doit etre OUVERTE pour etre cloturee");
        }

        sessionTruck.setFondDeCaisseCloture(fondDeCaisseCloture);
        sessionTruck.setStatutSession(statutCloturee);

        return sessionTruckRepository.save(sessionTruck);
    }

    public SessionTruck find(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id session null");
        }
        if (!sessionTruckRepository.existsById(id)) {
            throw new IllegalArgumentException("Session " + id + " introuvable");
        }
        return sessionTruckRepository.findById(id).orElse(null);
    }

    public List<SessionTruck> findSessionsDuJour() {
        return sessionTruckRepository.findByDateSession(LocalDate.now());
    }

    private void saveChauffeur(SessionTruck sessionTruck, Utilisateur chauffeur) {
        Role roleChauffeur = roleRepository.findByLibelle(ROLE_CHAUFFEUR);

        if (roleChauffeur == null) {
            throw new IllegalArgumentException("Role CHAUFFEUR introuvable");
        }

        EquipeSession equipeSession = new EquipeSession();
        equipeSession.setSessionTruck(sessionTruck);
        equipeSession.setUtilisateur(chauffeur);
        equipeSession.setRoleDuJour(roleChauffeur);

        equipeSessionRepository.save(equipeSession);
    }

    private Truck findTruck(Long idTruck) {
        if (idTruck == null) {
            throw new IllegalArgumentException("Id truck null");
        }
        if (!truckRepository.existsById(idTruck)) {
            throw new IllegalArgumentException("Truck " + idTruck + " introuvable");
        }
        return truckRepository.findById(idTruck).orElse(null);
    }

    private Itineraire findItineraire(Long idItineraire) {
        if (idItineraire == null) {
            throw new IllegalArgumentException("Id itineraire null");
        }
        if (!itineraireRepository.existsById(idItineraire)) {
            throw new IllegalArgumentException("Itineraire " + idItineraire + " introuvable");
        }
        return itineraireRepository.findById(idItineraire).orElse(null);
    }

    private Utilisateur findUtilisateur(Long idUtilisateur) {
        if (idUtilisateur == null) {
            throw new IllegalArgumentException("Id chauffeur null");
        }
        if (!utilisateurRepository.existsById(idUtilisateur)) {
            throw new IllegalArgumentException("Chauffeur " + idUtilisateur + " introuvable");
        }
        return utilisateurRepository.findById(idUtilisateur).orElse(null);
    }

    private StatutSession findStatutSession(String libelle) {
        StatutSession statutSession = statutSessionRepository.findByLibelle(libelle);
        if (statutSession == null) {
            throw new IllegalArgumentException("Statut session " + libelle + " introuvable");
        }
        return statutSession;
    }
}
