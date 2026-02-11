package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.PatenteRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.PatenteResponse;
import it.univaq.webengineering.soccorsoweb.service.PatenteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/swa/api/patenti")
@RequiredArgsConstructor
public class PatenteController {

    private final PatenteService patenteService;

    /**
     * GET /swa/api/patenti - Lista tutte le patenti disponibili
     */
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<List<PatenteResponse>> getAllPatenti() {
        return ResponseEntity.ok(patenteService.getAllPatenti());
    }

    /**
     * POST /swa/api/patenti - Crea una nuova patente
     */
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<PatenteResponse> createPatente(@RequestBody PatenteRequest request) {
        return ResponseEntity.ok(patenteService.creaPatente(request));
    }
}
