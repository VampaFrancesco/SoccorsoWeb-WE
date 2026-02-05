package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.security.Principal;

@Controller
public class MezziController {

    @GetMapping("/admin/mezzi")
    public String gestioneMezziAdmin(Model model, Principal principal) {
        setupModel(model, principal);

        model.addAttribute("basePath", "/admin");
        model.addAttribute("ruolo", "ADMIN");

        // Ritorna il template specifico per l'admin (src/main/resources/templates/admin/mezzi.ftl)
        return "admin/mezzi";
    }

    @GetMapping("/operatore/mezzi")
    public String visualizzaMezziOperatore(Model model, Principal principal) {
        setupModel(model, principal);

        model.addAttribute("basePath", "/operatore");
        model.addAttribute("ruolo", "OPERATORE");

        // Ritorna un template diverso (che creerai in futuro)
        return "operatore/mezzi";
    }

    // Metodo di utilità
    private void setupModel(Model model, Principal principal) {
        String username = "Ospite";
        if (principal != null) {
            username = principal.getName();
        }
        model.addAttribute("nomeUtente", username);
    }
}
