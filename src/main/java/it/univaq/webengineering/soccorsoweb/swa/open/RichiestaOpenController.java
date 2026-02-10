package it.univaq.webengineering.soccorsoweb.swa.open;

import it.univaq.webengineering.soccorsoweb.model.dto.request.ConvalidaRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.RichiestaSoccorsoRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.RichiestaSoccorsoResponse;
import it.univaq.webengineering.soccorsoweb.service.RichiestaService;
import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.RedirectView;
import java.net.URI;
import java.util.Map;

@RestController("richiestaOpenController")
@RequestMapping("/swa/open/richieste")
public class RichiestaOpenController {

    private final RichiestaService richiestaService;

    public RichiestaOpenController(RichiestaService richiestaService) {
        this.richiestaService = richiestaService;
    }

    /**
     * API 2: Inserisci nuova richiesta di soccorso
     * 
     * @param richiestaSoccorsoRequest
     * @return ResponseEntity<RichiestaSoccorsoResponse>
     */
    // POST /swa/open/richieste
    @PostMapping
    public ResponseEntity<RichiestaSoccorsoResponse> nuovaRichiesta(
            @Valid @RequestBody RichiestaSoccorsoRequest richiestaSoccorsoRequest,
            HttpServletRequest request) {

        RichiestaSoccorsoResponse response = richiestaService.nuovaRichiesta(richiestaSoccorsoRequest, request);

        return ResponseEntity
                .created(URI.create("/swa/open/richieste/" + response.getId()))
                .body(response);
    }

    // /**
    // * API 3: Convalida richiesta e redirect al servizio FreeMarker
    // * Questo endpoint viene chiamato direttamente dal link nell'email.
    // * Convalida immediatamente la richiesta e fa redirect al servizio FreeMarker
    // * che mostrerà la pagina di conferma.
    // *
    // * @param token_convalida Token di convalida ricevuto via email
    // * @return RedirectView verso il servizio FreeMarker con parametro di
    // * successo/errore
    // */
    // // GET /swa/open/richieste/convalida?token_convalida=...
    // @GetMapping("/convalida")
    // public RedirectView redirectConvalida(
    // @RequestParam("token_convalida") String token_convalida) {
    //
    // try {
    // // 1. Convalida immediatamente la richiesta
    // richiestaService.convalidaRichiesta(token_convalida);
    //
    // // 2. Redirect al servizio FreeMarker con successo
    // String redirectUrl = webServiceUrl + "/convalida?status=success";
    // return new RedirectView(redirectUrl);
    //
    // } catch (Exception e) {
    // // 3. In caso di errore, redirect con parametro di errore
    // String redirectUrl = webServiceUrl + "/convalida?status=error&message="
    // + java.net.URLEncoder.encode(e.getMessage(),
    // java.nio.charset.StandardCharsets.UTF_8);
    // return new RedirectView(redirectUrl);
    // }
    // }

    /**
     * API: Conferma convalida richiesta di soccorso
     * Chiamato dal frontend dopo che l'utente ha confermato
     * 
     * @param request ConvalidaRequest con token di convalida
     * @return ResponseEntity<Map<String, Object>>
     */
    // POST /swa/open/richieste/conferma-convalida
    @PostMapping("/conferma-convalida")
    public ResponseEntity<Map<String, String>> confermaConvalida(
            @Valid @RequestBody ConvalidaRequest request) {

        try {
            richiestaService.convalidaRichiesta(request.getTokenConvalida());

            return ResponseEntity.ok(
                    Map.of("success", "Richiesta convalidata con successo"));
        } catch (IllegalStateException e) {
            // Richiesta già convalidata
            return ResponseEntity.status(409).body(
                    Map.of("error", e.getMessage()));
        } catch (Exception e) {
            // Token non valido o già usato
            return ResponseEntity.status(404).body(
                    Map.of("error", e.getMessage()));
        }
    }
}
