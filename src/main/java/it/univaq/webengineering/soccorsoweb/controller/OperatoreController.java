package it.univaq.webengineering.soccorsoweb.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;


@Controller
@RequestMapping("/")
public class OperatoreController {


    @GetMapping("/operatore")
    public String operatore(Model model) {
        return "operatore/operatore";
    }

    @GetMapping("/operatore/missioni")
    public String paginaMissioni(
            @CookieValue(value = "operatore_id", required = false) String opId,
            Model model,
            Principal principal
    ) {
        // Passiamo l'id al template se esiste nel cookie, altrimenti passiamo null
        model.addAttribute("operatoreId", opId);
        model.addAttribute("nomeUtente", principal.getName());

        return "/operatore/operatore_missioni";
    }

}
