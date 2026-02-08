package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.security.Principal;

@Controller("profiloWebController")
public class ProfiloController {

    // AMMINISTRATORE
    @GetMapping("/admin/profilo")
    public String adminProfilo(Model model, Principal principal) {
        setupModel(model, principal);

        // Variabili Admin
        model.addAttribute("basePath", "/admin");
        model.addAttribute("ruolo", "ADMIN");

        return "profilo/profilo";
    }

    // OPERATORE
    @GetMapping("/operatore/profilo")
    public String operatoreProfilo(Model model, Principal principal) {
        setupModel(model, principal);

        // Variabili Operatore
        model.addAttribute("basePath", "/operatore");
        model.addAttribute("ruolo", "OPERATORE");

        return "profilo/profilo";
    }

    private void setupModel(Model model, Principal principal) {
        String username = "Ospite";
        if (principal != null) {
            username = principal.getName();
        }
        model.addAttribute("nomeUtente", username);
    }
}
