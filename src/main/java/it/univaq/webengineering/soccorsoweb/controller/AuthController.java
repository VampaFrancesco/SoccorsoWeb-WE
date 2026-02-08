package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller("authWebController")
public class AuthController {

    @GetMapping("/auth/login")
    public String showLoginPage() {
        return "auth/login";
    }

    @GetMapping("/auth/logout")
    public String showLogoutPage() {
        return "auth/logout";
    }

    @GetMapping("/auth/cambia-password")
    public String showChangePasswordPage() {
        return "auth/cambia_password";
    }
}

