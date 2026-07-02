package com.mkalymlam.controller;

import com.mkalymlam.dto.LoginRequest;
import com.mkalymlam.dto.RegisterRequest;
import com.mkalymlam.entity.Utilisateur;
import com.mkalymlam.service.AuthService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession; // ou jakarta.servlet.http.HttpSession selon votre version

@Controller
public class AuthViewController {

    private final AuthService authService;

    public AuthViewController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping("/login")
    public String loginForm() {
        return "auth/login"; // correspond à /WEB-INF/views/auth/login.jsp
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam String email,
                               @RequestParam String motDePasse,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        try {
            LoginRequest loginRequest = new LoginRequest();
            loginRequest.setEmail(email);
            loginRequest.setMotDePasse(motDePasse);

            Utilisateur user = authService.login(loginRequest);
            session.setAttribute("user", user);
            return "redirect:/dashboard"; // votre tableau de bord existant
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/login";
        }
    }

    @GetMapping("/register")
    public String registerForm() {
        return "auth/register"; // /WEB-INF/views/auth/register.jsp
    }

    @PostMapping("/register")
    public String processRegister(@RequestParam String nom,
                                  @RequestParam(required = false) String prenom,
                                  @RequestParam String email,
                                  @RequestParam String motDePasse,
                                  RedirectAttributes redirectAttributes) {
        try {
            RegisterRequest registerRequest = new RegisterRequest();
            registerRequest.setNom(nom);
            registerRequest.setPrenom(prenom);
            registerRequest.setEmail(email);
            registerRequest.setMotDePasse(motDePasse);

            authService.register(registerRequest);
            redirectAttributes.addFlashAttribute("success", "Inscription réussie, vous pouvez vous connecter.");
            return "redirect:/login";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/register";
        }
    }



    @GetMapping("/logout")
public String logout(HttpSession session) {
    session.invalidate();
    return "redirect:/login";
}
}