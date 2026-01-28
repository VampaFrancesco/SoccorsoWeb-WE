package it.univaq.webengineering.soccorsoweb.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@Controller("/home")
public class HomeController {

    @GetMapping("/index")
    public String index(Model model) {
        model.addAttribute("titolo", "Home Page");
        model.addAttribute("descrizione_h2", "Soccorso Web");
        model.addAttribute("descrizione_paragrafo",
                "Il portale per la gestione delle missioni di soccorso, piccolo, potente ed efficiente.");
        return "index";
    }

    @PostMapping("/richiesta")
    public ResponseEntity<?> richiesta(
            @RequestParam String nome_segnalante,
            @RequestParam String email_segnalante,
            @RequestParam String descrizione,
            @RequestParam Double latitudine,
            @RequestParam Double longitudine,
            @RequestParam(required = false) MultipartFile foto,
            @RequestParam(required = false) String capToken,
            HttpServletRequest request) {

        try {
            String ipAddress = request.getRemoteAddr();

            // Log dei dati ricevuti
            System.out.println("=== NUOVA RICHIESTA SOCCORSO ===");
            System.out.println("Nome: " + nome_segnalante);
            System.out.println("Email: " + email_segnalante);
            System.out.println("Descrizione: " + descrizione);
            System.out.println("Posizione: " + latitudine + ", " + longitudine);
            System.out.println("Foto: " + (foto != null ? foto.getOriginalFilename() : "Nessuna"));
            System.out.println("Cap Token: " + (capToken != null ? capToken : "Non fornito"));
            System.out.println("IP: " + ipAddress);
            System.out.println("================================");

            return ResponseEntity.ok(Map.of(
                    "message", "Richiesta ricevuta. Controlla la tua email per confermare."
            ));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError()
                    .body(Map.of("message", "Errore durante l'elaborazione della richiesta"));
        }
    }

    @GetMapping("/convalida_richiesta")
    public String convalida(@RequestParam(required = false) String token, Model model) {
        boolean success = token != null && !token.isEmpty();
        model.addAttribute("success", success);
        return "convalida_richiesta";
    }
}
