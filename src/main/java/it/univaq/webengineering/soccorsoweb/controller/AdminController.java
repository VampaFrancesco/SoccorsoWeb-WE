package it.univaq.webengineering.soccorsoweb.controller;

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

    @GetMapping("/admin/aggiungi-missione")
    public String nuovaMissione(Model model) {
        return "admin/aggiungi-missione";
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
}