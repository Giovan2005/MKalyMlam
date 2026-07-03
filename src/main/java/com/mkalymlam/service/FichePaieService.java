package com.mkalymlam.service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.FichePaie;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.repository.FichePaieRepository;
import com.mkalymlam.repository.UtilisateurRepository;

@Service
public class FichePaieService {

    private final FichePaieRepository fichePaieRepository;
    private final UtilisateurRepository utilisateurRepository;

    public FichePaieService(FichePaieRepository fichePaieRepository,
                            UtilisateurRepository utilisateurRepository) {
        this.fichePaieRepository = fichePaieRepository;
        this.utilisateurRepository = utilisateurRepository;
    }

    public List<FichePaie> findAll() {
        return fichePaieRepository.findAll();
    }

    public List<Utilisateur> findEmployes() {
        return utilisateurRepository.findAll().stream()
                .filter(utilisateur -> utilisateur.getSalaireBaseFixe() != null)
                .toList();
    }

    public FichePaie findById(Long idFiche) {
        if (idFiche == null) {
            throw new IllegalArgumentException("Id fiche nul");
        }
        return fichePaieRepository.findById(idFiche)
                .orElseThrow(() -> new IllegalArgumentException("Fiche de paie " + idFiche + " introuvable"));
    }

    public Optional<FichePaie> findExisting(Long idUtilisateur, String moisAnnee) {
        if (idUtilisateur == null || moisAnnee == null || moisAnnee.isBlank()) {
            return Optional.empty();
        }

        return fichePaieRepository.findByUtilisateur_IdAndMoisAnnee(idUtilisateur, moisAnnee);
    }

    @Transactional
    public FichePaie generer(Long idUtilisateur, String moisAnnee) {
        if (idUtilisateur == null) {
            throw new IllegalArgumentException("Employe obligatoire");
        }
        if (moisAnnee == null || moisAnnee.isBlank()) {
            throw new IllegalArgumentException("Mois et annee obligatoires");
        }

        YearMonth.parse(moisAnnee);

        Utilisateur utilisateur = utilisateurRepository.findById(idUtilisateur)
                .orElseThrow(() -> new IllegalArgumentException("Employe " + idUtilisateur + " introuvable"));

        Double salaireBaseFixe = utilisateur.getSalaireBaseFixe();
        if (salaireBaseFixe == null) {
            throw new IllegalArgumentException("L'employe selectionne n'a pas de salaire de base fixe");
        }

        FichePaie fichePaie = fichePaieRepository
                .findByUtilisateur_IdAndMoisAnnee(idUtilisateur, moisAnnee)
                .orElseGet(FichePaie::new);

        fichePaie.setUtilisateur(utilisateur);
        fichePaie.setMoisAnnee(moisAnnee);
        fichePaie.setMontantFixeBrut(salaireBaseFixe);
        fichePaie.setMontantNetVerse(salaireBaseFixe);
        fichePaie.setDatePaiement(LocalDate.now());

        return fichePaieRepository.save(fichePaie);
    }
}