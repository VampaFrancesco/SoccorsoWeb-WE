package it.univaq.webengineering.soccorsoweb.controller;

import it.univaq.webengineering.soccorsoweb.model.dto.response.UserResponse;
import it.univaq.webengineering.soccorsoweb.service.OperatoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;

@Controller("operatoreWebController")
@RequestMapping("/")
public class OperatoreController {

    @Autowired
    private OperatoreService operatoreService;

    @GetMapping("/operatore")
    public String operatore(Model model) {
        return "operatore/operatore";
    }

    @GetMapping("/operatore/missioni")
    public String paginaMissioni(
            @CookieValue(value = "operatore_id", required = false) String opId,
            Model model,
            Principal principal) {
        // Passiamo l'id al template se esiste nel cookie, altrimenti passiamo null
        model.addAttribute("operatoreId", opId);

        String username = "Ospite";
        if (principal != null) {
            username = principal.getName();
        }
        model.addAttribute("nomeUtente", username);

        return "/operatore/operatore_missioni";
    }

    @GetMapping("/operatore/profilo")
    public String profilo(Model model, Principal principal) {
        String username = "Ospite";
        if (principal != null) {
            username = principal.getName();
            UserResponse user = operatoreService.getProfile();
            model.addAttribute("user", user);
        }
        model.addAttribute("nomeUtente", username);
        model.addAttribute("basePath", "/operatore");
        return "operatore/profilo";
    }

}
