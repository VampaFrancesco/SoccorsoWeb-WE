package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ValidateEmailController {

    @GetMapping("/validate-email")
    public String validateEmailPage(@RequestParam("token") String token, Model model) {
        model.addAttribute("token", token);
        return "validate-email";
    }
}
