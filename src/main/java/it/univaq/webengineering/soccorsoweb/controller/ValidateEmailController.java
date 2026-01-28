package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ValidateEmailController {

    @GetMapping("/convalida")
    public String convalida(@RequestParam(name = "token_convalida", required = false) String tokenConvalida, Model model) {
        model.addAttribute("token_convalida", tokenConvalida);
        return "email/validate-email";
    }
}
