package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthController {

    @GetMapping("/login")
    public String showLoginPage() {
        return "auth/login";
    }

    @GetMapping("/logout")
    public String showLogoutPage() {
        return "auth/logout";
    }

    @GetMapping("/auth/cambia-password")
    public String showChangePasswordPage() {
        return "auth/cambia_password";
    }
}

