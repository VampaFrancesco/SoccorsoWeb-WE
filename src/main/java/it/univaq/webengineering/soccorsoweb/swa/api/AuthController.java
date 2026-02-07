package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.ChangePasswordRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.NuovoOperatoreRequest;
import it.univaq.webengineering.soccorsoweb.service.CredenzialiService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController("ApiAuthController")
@RequestMapping("/swa/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final CredenzialiService credenzialiService;

    @PostMapping("/registrazione")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> registrazione(@Valid @RequestBody NuovoOperatoreRequest request) {
        credenzialiService.registraNuovoOperatore(request);
        return ResponseEntity.ok().build();
    }

    /**
     * API: Marca il primo accesso come completato
     * Chiamato dal frontend dopo che l'utente ha fatto il primo login
     * 
     * @param userDetails Dettagli dell'utente autenticato
     * @return ResponseEntity<Void>
     */
    @PutMapping("/complete-first-login")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> completeFirstLogin(@AuthenticationPrincipal UserDetails userDetails) {
        credenzialiService.setFirstAttemptFalse(userDetails.getUsername());
        return ResponseEntity.ok().build();
    }

    @PutMapping("/change-password")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> changePassword(@RequestBody @Valid ChangePasswordRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        credenzialiService.changePassword(userDetails.getUsername(), request.getOldPassword(),
                request.getNewPassword());
        return ResponseEntity.ok().build();
    }
}
