package com.mkalymlam.controller;

import com.mkalymlam.dto.LoginRequest;
import com.mkalymlam.dto.RegisterRequest;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.service.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;  

@RestController
@RequestMapping("/api")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody RegisterRequest request) {
        try {
            authService.register(request);
            return ResponseEntity.ok("Inscription réussie.");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequest request, HttpSession session) {
        try {
            Utilisateur user = authService.login(request);
            session.setAttribute("user", user);
            return ResponseEntity.ok("Connexion réussie. Bienvenue " + user.getPrenom() + " " + user.getNom());
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        }
    }

    @GetMapping("/profile")
    public ResponseEntity<?> profile(HttpSession session) {
        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Vous n'êtes pas connecté.");
        }
        return ResponseEntity.ok(user);
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout(HttpSession session) {
        session.invalidate();
        return ResponseEntity.ok("Déconnexion réussie.");
    }
}