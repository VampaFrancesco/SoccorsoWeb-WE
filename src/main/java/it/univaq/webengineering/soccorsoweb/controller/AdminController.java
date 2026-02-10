package it.univaq.webengineering.soccorsoweb.controller;

import it.univaq.webengineering.soccorsoweb.service.OperatoreService;
import it.univaq.webengineering.soccorsoweb.model.dto.response.UserResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.security.Principal;

@Controller("adminWebController")
public class AdminController {

    @GetMapping("/admin")
    public String dashboard(Model model) {
        return "admin/admin";
    }

    @GetMapping("/admin/aggiungi-utente")
    public String nuovoOperatore(Model model) {
        return "admin/aggiungi-utente";
    }

    @GetMapping("/admin/missioni/nuova")
    public String nuovaMissione(Model model) {
        return "admin/nuova-missione";
    }

    @GetMapping("/admin/materiali")
    public String nuovoMateriale(Model model) {
        return "admin/materiali";
    }

    @GetMapping("/admin/richieste")
    public String richieste(Model model) {
        return "admin/richieste";
    }

    @GetMapping("/admin/missioni")
    public String missioni(Model model) {
        return "admin/missioni";
    }

    @GetMapping("/admin/operatori")
    public String operatori(Model model) {
        return "admin/operatori";
    }

    @Autowired
    private OperatoreService operatoreService;

    @GetMapping("/admin/profilo")
    public String adminProfilo(Model model, Principal principal) {
        String username = "Ospite";
        if (principal != null) {
            username = principal.getName();
            UserResponse user = operatoreService.getProfile();
            model.addAttribute("user", user);
        }
        model.addAttribute("nomeUtente", username);
        model.addAttribute("basePath", "/admin");
        model.addAttribute("ruolo", "ADMIN");

        return "admin/profilo";
    }
}