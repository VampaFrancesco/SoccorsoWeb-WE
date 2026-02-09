package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.response.AbilitaResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Abilita;
import it.univaq.webengineering.soccorsoweb.repository.AbilitaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/swa/api/abilita")
@RequiredArgsConstructor
public class AbilitaController {

    private final AbilitaRepository abilitaRepository;

    /**
     * GET /swa/api/abilita - Lista tutte le abilità disponibili
     */
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<List<AbilitaResponse>> getAllAbilita() {
        List<AbilitaResponse> abilita = abilitaRepository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(abilita);
    }

    /**
     * POST /swa/api/abilita - Crea una nuova abilità
     */
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<AbilitaResponse> createAbilita(@RequestBody AbilitaRequest request) {
        // Controlla se esiste già
        if (abilitaRepository.findByNome(request.getNome()).isPresent()) {
            return ResponseEntity.badRequest().build();
        }

        Abilita abilita = Abilita.builder()
                .nome(request.getNome())
                .descrizione(request.getDescrizione())
                .build();

        Abilita saved = abilitaRepository.save(abilita);
        return ResponseEntity.ok(toResponse(saved));
    }

    private AbilitaResponse toResponse(Abilita abilita) {
        AbilitaResponse response = new AbilitaResponse();
        response.setId(abilita.getId());
        response.setNome(abilita.getNome());
        response.setDescrizione(abilita.getDescrizione());
        return response;
    }

    // Inner class for request
    @lombok.Data
    public static class AbilitaRequest {
        private String nome;
        private String descrizione;
    }
}
