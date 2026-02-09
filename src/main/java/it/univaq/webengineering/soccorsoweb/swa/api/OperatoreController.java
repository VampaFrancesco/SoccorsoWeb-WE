package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.UserUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MissioneResponse;
import it.univaq.webengineering.soccorsoweb.model.dto.response.UserResponse;
import it.univaq.webengineering.soccorsoweb.service.MissioneService;
import it.univaq.webengineering.soccorsoweb.service.OperatoreService;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController("operatoreApiController")
@RequestMapping("/swa/api/operatori")
public @Data class OperatoreController {

    private final OperatoreService operatoreService;
    private final MissioneService missioneService;

    /**
     * API 6: Visualizza operatori disponibili
     * Metodo per visualizzare gli operatori disponibili
     * 
     * @return ResponseEntity<List<UserResponse>>
     */
    // GET /swa/api/operatori?disponibili=true
    @GetMapping
    @PreAuthorize("hasAnyRole('OPERATORE', 'ADMIN')")
    public ResponseEntity<List<UserResponse>> operatori(
            @RequestParam(required = false, defaultValue = "true") boolean disponibile) {

        return ResponseEntity.ok(operatoreService.operatoreDisponibile(disponibile));
    }

    /**
     * API 12: Visualizza dettagli operatore
     * Metodo per visualizzare i dettagli di un operatore
     * 
     * @return ResponseEntity<UserResponse>
     */
    // GET /swa/api/operatori/{id}
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('OPERATORE', 'ADMIN')")
    public ResponseEntity<UserResponse> dettagliOperatore(@PathVariable Long id) {
        return ResponseEntity.ok().body(operatoreService.dettagliOperatore(id));
    }

    /**
     * API 13: Liste missioni di uno specifico operatore
     * 
     * @param id
     * @return
     */
    // GET /swa/api/operatori/{id}/missioni
    @GetMapping("/{id}/missioni")
    @PreAuthorize("hasAnyRole('ADMIN','OPERATORE')")
    public ResponseEntity<List<MissioneResponse>> missioniOperatore(@PathVariable Long id) {
        return ResponseEntity.ok().body(missioneService.missioniOperatore(id));
    }

    /**
     * API: Liste missioni dell'operatore loggato
     */
    // GET /swa/api/operatori/me/missioni
    @GetMapping("/me/missioni")
    @PreAuthorize("hasRole('OPERATORE')")
    public ResponseEntity<List<MissioneResponse>> myMissioni() {
        UserResponse profile = operatoreService.getProfile();
        return ResponseEntity.ok().body(missioneService.missioniOperatore(profile.getId()));
    }

    /**
     * API: Get Current Profile
     * Metodo per ottenere il profilo dell'utente loggato.
     * 
     * @return ResponseEntity<UserResponse>
     */
    // GET /swa/api/operatori/me
    @GetMapping("/me")
    @PreAuthorize("hasAnyRole('OPERATORE', 'ADMIN')")
    public ResponseEntity<UserResponse> getMyProfile() {
        return ResponseEntity.ok(operatoreService.getProfile());
    }

    /**
     * API: Update Current Profile
     * Metodo per aggiornare il profilo dell'utente loggato.
     * 
     * @param request
     * @return ResponseEntity<UserResponse>
     */
    // PATCH /swa/api/operatori/me
    @PatchMapping("/me")
    @PreAuthorize("hasAnyRole('OPERATORE', 'ADMIN')")
    public ResponseEntity<UserResponse> updateMyProfile(
            @RequestBody UserUpdateRequest request) {
        return ResponseEntity.ok(operatoreService.updateProfile(request));
    }

    /**
     * API: Elimina utente (Admin)
     * Metodo per eliminare un operatore.
     * 
     * @param id
     * @return ResponseEntity<Void>
     */
    // DELETE /swa/api/operatori/{id}
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        operatoreService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
}
