package it.univaq.webengineering.soccorsoweb.controller;

import it.univaq.webengineering.soccorsoweb.model.dto.response.UserResponse;
import it.univaq.webengineering.soccorsoweb.service.OperatoreService;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.security.Principal;

@ControllerAdvice
public class GlobalControllerAdvice {

    private final OperatoreService operatoreService;

    public GlobalControllerAdvice(OperatoreService operatoreService) {
        this.operatoreService = operatoreService;
    }

    @ModelAttribute
    public void populateUser(Model model, Principal principal) {
        if (principal != null) {
            try {
                UserResponse user = operatoreService.getProfile();
                model.addAttribute("loggedUser", user);
                // Also override nomeUtente if not set or just provide it for legacy
                // compatibility
                // We prefer using loggedUser in templates now
            } catch (Exception e) {
                // User might not be found or other issue, just ignore to not break the page
            }
        }
    }
}
