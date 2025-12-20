package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class IndexController {

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("titolo", "Home Page");
        model.addAttribute("descrizione_h2", "Soccorso web");
        model.addAttribute("descrizione_paragrafo", "Il portale per la gestione delle missioni di soccorso, piccolo, potente ed efficiente.");
        return "index";
    }

    @PostMapping("/richiesta")
    public String richiesta() {
        ResponseEntity.ok("Richiesta ricevuta con successo!");
        return "redirect:/convalida_richiesta";
    }

    @GetMapping("/convalida_richiesta")
    public String convalida() {
        ResponseEntity.ok("Richiesta ricevuta con successo!"); //invio mail di conferma
        return "convalida_richiesta";
    }
}
