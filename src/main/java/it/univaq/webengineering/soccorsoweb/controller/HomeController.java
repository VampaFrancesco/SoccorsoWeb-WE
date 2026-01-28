package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller("/")
public class HomeController {

    @GetMapping("/home")
    public String home(Model model) {
        model.addAttribute("titolo", "Home Page");
        model.addAttribute("descrizione_h2", "Soccorso Web");
        model.addAttribute("descrizione_paragrafo",
                "Il portale per la gestione delle missioni di soccorso, piccolo, potente ed efficiente.");
        return "home";
    }
}
