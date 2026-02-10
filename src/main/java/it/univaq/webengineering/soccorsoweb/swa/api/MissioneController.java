package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.MissioneRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.MissioneUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MissioneResponse;
import it.univaq.webengineering.soccorsoweb.service.MissioneService;
import jakarta.validation.Valid;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController("missioneApiController")
@RequestMapping("/swa/api/missioni")
@Data
public class MissioneController {

    private final MissioneService missioneService;

    // ============================
    // API PRINCIPALI
    // ============================

    /** API 7 - Crea una nuova missione */
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MissioneResponse> inserisciMissione(
            @Valid @RequestBody MissioneRequest missioneRequest) {
        return ResponseEntity.ok(missioneService.inserisciMissione(missioneRequest));
    }

    /** API 8 - Chiude una missione (endpoint dedicato) */
    @PatchMapping("/{id}/chiusura")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MissioneResponse> chiudiMissione(@PathVariable Long id) {
        return ResponseEntity.ok(missioneService.chiudiMissione(id));
    }

    /** API 10 - Dettagli di una missione */
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MissioneResponse> dettagliMissione(@PathVariable Long id) {
        return ResponseEntity.ok(missioneService.dettagliMissione(id));
    }

    /** Aggiorna parzialmente una missione (PATCH) */
    @PatchMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MissioneResponse> aggiornaMissione(
            @PathVariable Long id,
            @Valid @RequestBody MissioneUpdateRequest updateRequest) {
        return ResponseEntity.ok(missioneService.aggiornaMissione(id, updateRequest));
    }

    /** Lista di tutte le missioni */
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<List<MissioneResponse>> tutteLeMissioni() {
        return ResponseEntity.ok(missioneService.tutteLeMissioni());
    }

    // ============================
    // API DI SUPPORTO
    // ============================

    /** Modifica solo lo stato di una missione */
    @PatchMapping("/{id}/modifica-stato")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MissioneResponse> modificaStatoMissione(
            @PathVariable Long id,
            @RequestParam("nuovo_stato") String nuovoStato) {
        return ResponseEntity.ok(missioneService.modificaMissione(id, nuovoStato));
    }

    /** Elimina una missione */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> eliminaMissione(@PathVariable Long id) {
        missioneService.eliminaMissione(id);
        return ResponseEntity.noContent().build();
    }
}
