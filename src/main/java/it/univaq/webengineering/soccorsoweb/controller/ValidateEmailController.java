package it.univaq.webengineering.soccorsoweb.controller;

import it.univaq.webengineering.soccorsoweb.service.RichiestaService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Controller per la pagina di convalida email.
 * <p>
 * Supporta Progressive Enhancement:
 * - GET /convalida?token_convalida=... → mostra pagina con form/JS
 * - POST /convalida (form submit no-JS) → esegue la convalida server-side
 * - Se JS è attivo, il JS invia la convalida via AJAX e nasconde il form
 */
@Controller
public class ValidateEmailController {

    private final RichiestaService richiestaService;

    public ValidateEmailController(RichiestaService richiestaService) {
        this.richiestaService = richiestaService;
    }

    /**
     * GET: Mostra la pagina di convalida con il token nell'URL.
     * Il template mostrerà un form POST (no-JS) o lo spinner AJAX (JS).
     */
    @GetMapping("/convalida")
    public String convalida(
            @RequestParam(name = "token_convalida", required = false) String tokenConvalida,
            Model model) {
        model.addAttribute("token_convalida", tokenConvalida);
        return "email/validate-email";
    }

    /**
     * POST: Esegue la convalida senza JavaScript (form submit tradizionale).
     * Riceve il token_convalida via form-urlencoded.
     */
    @PostMapping("/convalida")
    public String confermaConvalida(
            @RequestParam("token_convalida") String tokenConvalida,
            Model model) {

        model.addAttribute("convalidaEseguita", true);

        try {
            richiestaService.convalidaRichiesta(tokenConvalida);
            model.addAttribute("convalidaSuccesso", true);

        } catch (IllegalStateException e) {
            // Richiesta già convalidata
            model.addAttribute("convalidaSuccesso", false);
            model.addAttribute("convalidaErroreTitolo", "Già Convalidata");
            model.addAttribute("convalidaErroreMessaggio",
                    "Questa richiesta è già stata convalidata in precedenza. Il link è utilizzabile una sola volta.");

        } catch (EntityNotFoundException e) {
            // Token non valido
            model.addAttribute("convalidaSuccesso", false);
            model.addAttribute("convalidaErroreTitolo", "Link Non Valido");
            model.addAttribute("convalidaErroreMessaggio",
                    "Il link di convalida non è valido oppure è già stato utilizzato. Ogni link può essere usato una sola volta.");

        } catch (Exception e) {
            model.addAttribute("convalidaSuccesso", false);
            model.addAttribute("convalidaErroreTitolo", "Errore");
            model.addAttribute("convalidaErroreMessaggio",
                    "Si è verificato un errore durante la convalida. Riprova più tardi.");
        }

        return "email/validate-email";
    }
}
