package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.RichiestaSoccorsoUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MissioneResponse;
import it.univaq.webengineering.soccorsoweb.model.dto.response.RichiestaSoccorsoResponse;
import it.univaq.webengineering.soccorsoweb.service.RichiestaService;

import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController("richiestaApiController")
@RequestMapping("/swa/api/richieste")
public class RichiestaApiController {

    public final RichiestaService richiestaService;

    public RichiestaApiController(RichiestaService richiestaService) {
        this.richiestaService = richiestaService;

    }

    /**
     * API 4: Visualizza richieste filtrate per stato (PAGINATA)
     * 
     * @param stato Stato della richiesta (INVIATA, CONVALIDATA, ecc.)
     * @param page  Numero pagina (0-based, default: 0)
     * @param size  Elementi per pagina (default: 20, max: 100)
     * @return ResponseEntity<Page<RichiestaSoccorsoResponse>>
     */
    // GET /swa/api/richieste?stato=CONVALIDATA&page=0&size=20
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<Page<RichiestaSoccorsoResponse>> richiesteFiltrate(
            @RequestParam("stato") String stato,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "20") int size) {
        // Validazione size (opzionale ma buona pratica)
        if (size > 100) {
            size = 100; // Limita a max 100 elementi per evitare sovraccarico
        }

        // Crea oggetto Pageable
        Pageable pageable = PageRequest.of(page, size);

        // Chiama service con paginazione
        Page<RichiestaSoccorsoResponse> response = richiestaService.richiesteFiltrate(stato, pageable);

        // Verifica se la pagina ha contenuto
        if (response.hasContent()) {
            return ResponseEntity.ok().body(response);
        }

        // Restituisce 204 No Content se la pagina è vuota
        return ResponseEntity.noContent().build();
    }

    /**
     * API 9: Annulla richiesta di soccorso
     * Metodo per l'annullamento di una richiesta di soccorso
     * 
     * @param id ID della richiesta di soccorso
     * @return ResponseEntity<RichiestaSoccorsoResponse>
     */
    // PATCH /swa/api/richieste/{id}/annullamento
    @PatchMapping("/{id}/annullamento")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<RichiestaSoccorsoResponse> annullaRichiestaSoccorso(@PathVariable Long id) {
        return ResponseEntity.ok().body(richiestaService.annullaRichiesta(id));
    }

    /**
     * API 11: Dettagli richiesta di soccorso
     * Metodo per visualizzare i dettagli di una richiesta di soccorso
     * 
     * @param id ID della richiesta di soccorso
     * @return ResponseEntity<RichiestaSoccorsoResponse>
     */
    // GET /swa/api/richieste/{id}
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<RichiestaSoccorsoResponse> dettagliRichiesta(@PathVariable Long id) {
        return ResponseEntity.ok().body(richiestaService.dettagliRichiesta(id));
    }

    /**
     * API: Modifica richiesta di soccorso
     * Metodo per modificare parzialmente una richiesta di soccorso
     * 
     * @param id            ID della richiesta di soccorso
     * @param updateRequest Dati da aggiornare
     * @return ResponseEntity<RichiestaSoccorsoResponse>
     */
    // PATCH /swa/api/richieste/{id}
    @PatchMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<RichiestaSoccorsoResponse> aggiornaRichiesta(
            @PathVariable Long id,
            @Valid @RequestBody RichiestaSoccorsoUpdateRequest updateRequest) {
        return ResponseEntity.ok().body(richiestaService.aggiornaRichiesta(id, updateRequest));
    }

    /**
     * API 5: Visualizza richieste chiuse valutate negativamente < 5
     * NOTA: Questo endpoint è stato spostato su MissioneController perché
     * livello_successo è un campo della tabella missione, non richiesta_soccorso.
     * Vedi: GET /swa/api/missioni/non-positive
     */
    // GET /swa/api/richieste/non-positive
    // @GetMapping("/non-positive")
    // @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    // public ResponseEntity<List<RichiestaSoccorsoResponse>>
    // richiesteValutateNegative() {
    // return
    // ResponseEntity.ok().body(richiestaService.richiesteValutateNegative());
    // }

    // ------------------------------------------ API SUPPORTO
    // ------------------------------------------

    // DELETE /swa/api/richieste/{id}
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> eliminaMissione(@PathVariable Long id) {
        richiestaService.eliminaRichiesta(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * API di supporto: modifica stato richiesta
     * Metodo per la modifica dello stato di una richiesta di soccorso
     * 
     * @param id    ID della missione
     * @param stato Nuovo stato
     *              ('INVIATA','ATTIVA','CONVALIDATA','IN_CORSO','CHIUSA','IGNORATA')
     * @return ResponseEntity<RichiestaSoccorsoResponse>
     */
    // PATCH /swa/api/richieste/{id}/stato
    @PatchMapping("/{id}/stato")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<RichiestaSoccorsoResponse> modificaStatoRichiesta(
            @PathVariable Long id,
            @RequestParam("stato") String stato) {
        RichiestaSoccorsoResponse response = richiestaService.modificaRichiesta(id, stato);

        if (response != null) {
            return ResponseEntity.ok().body(response);
        }
        return ResponseEntity.noContent().build();
    }

    /**
     * API di supporto: valuta richiesta
     * NOTA: Questo endpoint è stato spostato su MissioneController perché
     * livello_successo è un campo della tabella missione, non richiesta_soccorso.
     * Vedi: PATCH /swa/api/missioni/{id}/valutazione
     */
    // PATCH /swa/api/richieste/{id}/valutazione
    // @PatchMapping("/{id}/valutazione")
    // @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    // public ResponseEntity<RichiestaSoccorsoResponse> valutaRichiesta(
    // @PathVariable Long id,
    // @RequestParam("valutazione") Integer valutazione) {
    // return ResponseEntity.ok().body(richiestaService.valutaRichiesta(id,
    // valutazione));
    // }
}
