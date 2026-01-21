package it.univaq.webengineering.soccorsoweb.controller;

import it.univaq.webengineering.soccorsoweb.model.dto.AuthRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.AuthResponse;
import it.univaq.webengineering.soccorsoweb.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/auth/v1")
public class AuthController {

    public final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public String login(@RequestBody AuthRequest authRequest) {
        ResponseEntity<AuthResponse> r = authService.login(authRequest);
        if(r.getStatusCode().is2xxSuccessful()){
            return "redirect:/dashboard_operatore.ftl";
        }
        return "redirect:/404";
    }
}
