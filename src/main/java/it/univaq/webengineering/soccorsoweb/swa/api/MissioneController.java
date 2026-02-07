package it.univaq.webengineering.soccorsoweb.swa.api;


import it.univaq.webengineering.soccorsoweb.model.dto.request.MissioneRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.MissioneUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MissioneResponse;
import it.univaq.webengineering.soccorsoweb.service.MissioneService;
import jakarta.validation.Valid;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/swa/api/missioni")
@Data
public class MissioneController {

    private final MissioneService missioneService;


    /** API 7: Inserimento di una nuova missione
     * Metodo per l'inserimento di una nuova missione a cui viene legata una richiesta di soccorso
     * @param missioneRequest MissioneRequest
     * @return ResponseEntity<MissioneResponse>
     */
    // POST /swa/api/missioni
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MissioneResponse> inserisciMissione(
            @Valid @RequestBody MissioneRequest missioneRequest) {
        return ResponseEntity.ok().body(missioneService.inserisciMissione(missioneRequest));
    }


    /** API 8: Chiusura missione
     * Metodo per la chiusura di una missione
     */
    // PATCH /swa/api/missioni/{id}/chiusura
    @PatchMapping("/{id}/chiusura")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MissioneResponse> chiudiMissione(
            @PathVariable Long id
    ) {
        return ResponseEntity.ok().body(missioneService.chiudiMissione(id));
    }


    /** API 10: Dettagli missione
     * Metodo per ottenere i dettagli di una missione tramite ID
     * @param id ID della missione
     * @return ResponseEntity<MissioneResponse>
     */
    // GET /swa/api/missioni/{id}
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OPERATORE')")
    public ResponseEntity<MissioneResponse> dettagliMissione(@PathVariable Long id){
        return ResponseEntity.ok().body(missioneService.dettagliMissione(id));
    }

    /** API: Modifica missione
     * Metodo per modificare parzialmente una missione
     * @param id ID della missione
     * @param updateRequest Dati da aggiornare
     * @return ResponseEntity<MissioneResponse>
     */
    // PATCH /swa/api/missioni/{id}
    @PatchMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MissioneResponse> aggiornaMissione(
            @PathVariable Long id,
            @Valid @RequestBody MissioneUpdateRequest updateRequest) {
        return ResponseEntity.ok().body(missioneService.aggiornaMissione(id, updateRequest));
    }




// ---------------------------------------------------------------------- API SUPPORTO ----------------------------------------------------------------------


    /** API di supporto: modifica stato missione
     * Metodo per la modifica dello stato di una missione
     * @param id ID della missione
     * @param nuovoStato Nuovo stato (IN_CORSO, CHIUSA, FALLITA)
     * @return ResponseEntity<MissioneResponse>
     */
    @PatchMapping("/{id}/modifica-stato")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MissioneResponse> modificaStatoMissione(
            @PathVariable Long id,
            @RequestParam("nuovo_stato") String nuovoStato) {
        MissioneResponse response = missioneService.modificaMissione(id, nuovoStato);

        if (response != null) {
            return ResponseEntity.ok().body(response);
        }
        return ResponseEntity.noContent().build();
    }

    /**
     * API di supporto: elimina missione
     * Metodo per eliminare una missione tramite ID
     * @return 204 No Content
     */
    // DELETE /swa/api/missioni/{id}
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> eliminaMissione(@PathVariable Long id) {
        missioneService.eliminaMissione(id);
        return ResponseEntity.noContent().build();
    }


    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<List<MissioneResponse>> tutteLeMissioni() {
        return ResponseEntity.ok().body(missioneService.tutteLeMissioni());
    }



}
