package it.univaq.webengineering.soccorsoweb.controller;

import it.univaq.webengineering.soccorsoweb.model.dto.request.RichiestaSoccorsoRequest;
import it.univaq.webengineering.soccorsoweb.service.RichiestaService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Random;

@Controller("homeWebController")
public class HomeController {

    private final RichiestaService richiestaService;
    private final Random random = new Random();

    @Value("${app.captcha.secret:SoccorsoWebCaptchaSecret2026!}")
    private String captchaSecret;

    public HomeController(RichiestaService richiestaService) {
        this.richiestaService = richiestaService;
    }

    @GetMapping({ "/", "/home" })
    public String home(Model model) {
        model.addAttribute("titolo", "Home Page");
        model.addAttribute("descrizione_h2", "Soccorso Web");
        model.addAttribute("descrizione_paragrafo",
                "Il portale per la gestione delle missioni di soccorso, piccolo, potente ed efficiente.");

        // Genera captcha matematica server-side
        generaCaptcha(model);

        return "home";
    }

    @PostMapping("/richiesta-soccorso")
    public String inviaSoccorso(
            @RequestParam("nomeSegnalante") String nomeSegnalante,
            @RequestParam("emailSegnalante") String emailSegnalante,
            @RequestParam(value = "telefonoSegnalante", required = false) String telefonoSegnalante,
            @RequestParam("descrizione") String descrizione,
            @RequestParam("indirizzo") String indirizzo,
            @RequestParam(value = "latitudine", required = false) String latitudinStr,
            @RequestParam(value = "longitudine", required = false) String longitudinStr,
            @RequestParam(value = "foto", required = false) MultipartFile foto,
            @RequestParam(value = "captchaRisposta", required = false) String captchaRisposta,
            @RequestParam(value = "captchaId", required = false) String captchaId,
            @RequestParam(value = "captchaToken", required = false) String captchaToken,
            HttpServletRequest httpRequest,
            Model model) {

        // Re-popola attributi di base per il template
        model.addAttribute("titolo", "Home Page");

        try {
            // 1. Verifica captcha (se non c'è token JS, verifica la risposta matematica)
            if (captchaToken == null || captchaToken.isBlank()) {
                verificaCaptchaMatematica(captchaRisposta, captchaId);
            }
            // Se c'è captchaToken, il captcha JS è stato completato (fiducia lato client)

            // 2. Costruisci il DTO della richiesta
            RichiestaSoccorsoRequest request = new RichiestaSoccorsoRequest();
            request.setNomeSegnalante(nomeSegnalante);
            request.setEmailSegnalante(emailSegnalante);
            request.setTelefonoSegnalante(telefonoSegnalante);
            request.setDescrizione(descrizione);
            request.setIndirizzo(indirizzo);

            // Parse coordinate (possono essere vuote senza JS/GPS)
            if (latitudinStr != null && !latitudinStr.isBlank()) {
                try {
                    request.setLatitudine(new BigDecimal(latitudinStr));
                } catch (NumberFormatException ignored) {
                }
            }
            if (longitudinStr != null && !longitudinStr.isBlank()) {
                try {
                    request.setLongitudine(new BigDecimal(longitudinStr));
                } catch (NumberFormatException ignored) {
                }
            }

            // Foto: converti MultipartFile in byte[]
            if (foto != null && !foto.isEmpty()) {
                request.setFoto(foto.getBytes());
            }

            // 3. Chiama il servizio
            richiestaService.nuovaRichiesta(request, httpRequest);

            // 4. Successo → mostra messaggio
            model.addAttribute("successMessage",
                    "La tua richiesta è stata registrata. Controlla la tua email (" +
                            emailSegnalante + ") per confermare la richiesta");

        } catch (IllegalStateException e) {
            model.addAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            model.addAttribute("errorMessage",
                    "Si è verificato un errore durante l'invio della richiesta");
        }

        // Rigenera captcha per il prossimo tentativo
        generaCaptcha(model);

        return "home";
    }

    private void generaCaptcha(Model model) {
        int a = random.nextInt(10) + 1; // 1-10
        int b = random.nextInt(10) + 1; // 1-10
        int risultato = a + b;

        String domanda = a + " + " + b;
        long timestamp = System.currentTimeMillis();

        // Crea payload firmato: "risultato:timestamp"
        String payload = risultato + ":" + timestamp;
        String hmac = hmacSha256(payload);
        String captchaId = Base64.getEncoder().encodeToString(
                (payload + ":" + hmac).getBytes(StandardCharsets.UTF_8));

        model.addAttribute("captchaDomanda", domanda);
        model.addAttribute("captchaId", captchaId);
    }

   // Verifica risposta matematica
    private void verificaCaptchaMatematica(String risposta, String captchaId) {
        if (captchaId == null || captchaId.isBlank()) {
            throw new IllegalStateException("Captcha non valido. Ricarica la pagina e riprova");
        }

        if (risposta == null || risposta.isBlank()) {
            throw new IllegalStateException("Devi rispondere alla domanda di sicurezza");
        }

        try {
            // Decodifica il captchaId
            String decoded = new String(Base64.getDecoder().decode(captchaId), StandardCharsets.UTF_8);
            String[] parts = decoded.split(":");
            if (parts.length != 3) {
                throw new IllegalStateException("Captcha corrotto. Ricarica la pagina.");
            }

            int risultatoCorretto = Integer.parseInt(parts[0]);
            long timestamp = Long.parseLong(parts[1]);
            String hmacRicevuto = parts[2];

            // Verifica HMAC
            String payload = risultatoCorretto + ":" + timestamp;
            String hmacCalcolato = hmacSha256(payload);
            if (!hmacCalcolato.equals(hmacRicevuto)) {
                throw new IllegalStateException("Captcha manomesso. Ricarica la pagina.");
            }

            // Verifica scadenza (5 minuti)
            if (System.currentTimeMillis() - timestamp > 5 * 60 * 1000) {
                throw new IllegalStateException("Il captcha è scaduto. Ricarica la pagina e riprova");
            }

            // Verifica risposta
            int userAnswer = Integer.parseInt(risposta.trim());
            if (userAnswer != risultatoCorretto) {
                throw new IllegalStateException("Risposta alla domanda di sicurezza errata. Riprova");
            }

        } catch (NumberFormatException e) {
            throw new IllegalStateException("La risposta deve essere un numero");
        } catch (IllegalArgumentException e) {
            throw new IllegalStateException("Captcha non valido. Ricarica la pagina");
        }
    }

    private String hmacSha256(String message) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKey = new SecretKeySpec(
                    captchaSecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(secretKey);
            byte[] hash = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("Errore calcolo HMAC", e);
        }
    }
}
