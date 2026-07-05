package com.mkalymlam.service;

import com.mkalymlam.entity.AbsenceConge;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.repository.AbsenceCongeRepository;
import com.mkalymlam.repository.UtilisateurRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CongeService {

    private final AbsenceCongeRepository absenceRepo;
    private final UtilisateurRepository utilisateurRepo;

    // Constantes pour les IDs (basées sur vos insertions)
    public static final int STATUT_EN_ATTENTE = 1;
    public static final int STATUT_VALIDE = 2;
    public static final int STATUT_REFUSE = 3;

    public static final int TYPE_CONGE_PAYE = 1;
    public static final int TYPE_ABSENCE_MALADIE = 2;
    public static final int TYPE_ABSENCE_INJUSTIFIEE = 3;
    public static final int TYPE_CONGE_EXCEPTIONNEL = 4;

    public CongeService(AbsenceCongeRepository absenceRepo, UtilisateurRepository utilisateurRepo) {
        this.absenceRepo = absenceRepo;
        this.utilisateurRepo = utilisateurRepo;
    }

    public List<AbsenceConge> findAll() {
        return absenceRepo.findAllByOrderByIdAbsenceDesc();
    }

    public Optional<AbsenceConge> findById(Integer id) {
        return absenceRepo.findById(id);
    }

    public AbsenceConge demanderConge(Integer idUtilisateur, Integer idTypeConge,
                                      LocalDate dateDebut, LocalDate dateFin,
                                      BigDecimal deduction, Integer idRemplacant) {
        AbsenceConge absence = new AbsenceConge();
        absence.setIdUtilisateur(idUtilisateur);
        absence.setIdTypeConge(idTypeConge);
        absence.setDateDebut(dateDebut);
        absence.setDateFin(dateFin);
        absence.setIdStatutValidation(STATUT_EN_ATTENTE);
        absence.setDeductionSalaireAppliquee(deduction != null ? deduction : BigDecimal.ZERO);
        absence.setIdRemplacant(idRemplacant);
        return absenceRepo.save(absence);
    }

    public void valider(Integer idAbsence) {
        AbsenceConge absence = absenceRepo.findById(idAbsence)
                .orElseThrow(() -> new RuntimeException("Absence introuvable"));
        absence.setIdStatutValidation(STATUT_VALIDE);
        absenceRepo.save(absence);
    }

    public void refuser(Integer idAbsence) {
        AbsenceConge absence = absenceRepo.findById(idAbsence)
                .orElseThrow(() -> new RuntimeException("Absence introuvable"));
        absence.setIdStatutValidation(STATUT_REFUSE);
        absenceRepo.save(absence);
    }

    public String getTypeCongeLibelle(int idType) {
        return switch (idType) {
            case TYPE_CONGE_PAYE -> "Congé payé";
            case TYPE_ABSENCE_MALADIE -> "Absence maladie";
            case TYPE_ABSENCE_INJUSTIFIEE -> "Absence injustifiée";
            case TYPE_CONGE_EXCEPTIONNEL -> "Congé exceptionnel";
            default -> "Inconnu";
        };
    }

    public String getStatutLibelle(int idStatut) {
        return switch (idStatut) {
            case STATUT_EN_ATTENTE -> "En attente";
            case STATUT_VALIDE -> "Validé";
            case STATUT_REFUSE -> "Refusé";
            default -> "Inconnu";
        };
    }

    public List<Utilisateur> getAllEmployes() {
        return utilisateurRepo.findAll();
    }

    public Optional<Utilisateur> getEmployeById(Integer id) {
        return utilisateurRepo.findById(id);
    }
}