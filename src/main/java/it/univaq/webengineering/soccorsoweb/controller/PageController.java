package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    // 1. Mostra la pagina di login
    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    // 2. Mostra la dashboard dopo il login
    @GetMapping("/dashboard_operatore.ftl")
    public String showDashboard() {
        return "dashboard_operatore";
    }
}
