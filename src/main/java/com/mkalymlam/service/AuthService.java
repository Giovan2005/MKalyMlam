package com.mkalymlam.service;

import com.mkalymlam.dto.LoginRequest;
import com.mkalymlam.dto.RegisterRequest;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.repository.UtilisateurRepository;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UtilisateurRepository utilisateurRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    // On définit un rôle par défaut (par ex. 1 = "Employé")
    private static final int ROLE_DEFAUT = 1;

    public AuthService(UtilisateurRepository utilisateurRepository) {
        this.utilisateurRepository = utilisateurRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    public Utilisateur register(RegisterRequest request) {
        if (utilisateurRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Cet email est déjà utilisé.");
        }

        Utilisateur user = new Utilisateur();
        user.setNom(request.getNom());
        user.setPrenom(request.getPrenom());
        user.setEmail(request.getEmail());
        user.setMotDePasse(passwordEncoder.encode(request.getMotDePasse()));
        user.setIdRole(ROLE_DEFAUT);
        user.setStatutActif(true);

        return utilisateurRepository.save(user);
    }

    public Utilisateur login(LoginRequest request) {
        Utilisateur user = utilisateurRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Email ou mot de passe incorrect."));

        if (!passwordEncoder.matches(request.getMotDePasse(), user.getMotDePasse())) {
            throw new RuntimeException("Email ou mot de passe incorrect.");
        }

        if (!user.getStatutActif()) {
            throw new RuntimeException("Ce compte est désactivé.");
        }

        return user;
    }
}