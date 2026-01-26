package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.view.RedirectView;

@Controller
public class ConvalidaController {

    @Value("${api.base.url}")
    private String apiBaseUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    @PostMapping("/convalida")
    public RedirectView convalida(@RequestParam String token, Model model){
            try{
                String url = apiBaseUrl + "/convalida?token=" + token;
                restTemplate.getForObject(url, String.class);
                model.addAttribute("esito", "Convalida avvenuta con successo!");
                model.addAttribute("messaggio", "La tua richiesta di soccorso è stata convalidata correttamente.");
                return new RedirectView("redirect:/esito");
            }catch(Exception e){
                model.addAttribute("esito", "Convalida non avvenuta con successo!");
                model.addAttribute("messaggio", "La tua richiesta di soccorso non è stata convalidata correttamente.");
                return new RedirectView("redirect:/esito");
            }
    }
}
