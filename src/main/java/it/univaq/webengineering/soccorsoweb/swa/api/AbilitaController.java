package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.AbilitaRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.AbilitaResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Abilita;
import it.univaq.webengineering.soccorsoweb.repository.AbilitaRepository;
import it.univaq.webengineering.soccorsoweb.service.AbilitaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.encrypt.RsaKeyHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/swa/api/abilita")
@RequiredArgsConstructor
public class AbilitaController {

    private final AbilitaService abilitaService;

    /**
     * GET /swa/api/abilita - Lista tutte le abilità disponibili
     */
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<List<AbilitaResponse>> getAllAbilita() {
        return ResponseEntity.ok(abilitaService.getAllAbilita());
    }

    /**
     * POST /swa/api/abilita - Crea una nuova abilità
     */
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<AbilitaResponse> createAbilita(@RequestBody AbilitaRequest request) {
        return ResponseEntity.ok(abilitaService.creaAbilita(request));
    }


}
