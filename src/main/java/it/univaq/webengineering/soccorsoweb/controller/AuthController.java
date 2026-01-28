package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthController {

    // 1. Mostra la pagina di login
    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }
}
