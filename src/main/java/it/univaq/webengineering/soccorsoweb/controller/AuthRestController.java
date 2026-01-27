package it.univaq.webengineering.soccorsoweb.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/swa/open/auth")
public class AuthRestController {

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> payload) {

        // 1. Estrai i dati inviati dal JS
        String email = payload.get("email");
        String password = payload.get("password");

        // 2. Logica di controllo (MOCK)
        if ("admin@soccorso.it".equals(email) && "password123".equals(password)) {

            // SUCCESSO
            return ResponseEntity.ok(Map.of(
                    "accessToken", "token_jwt_simulato_xyz",
                    "message", "Login riuscito"
            ));

        } else {

            // ERRORE
            return ResponseEntity.status(401).body(Map.of(
                    "message", "Credenziali non valide"
            ));
        }
    }
}
