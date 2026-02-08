package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.SquadraRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.SquadraResponse;
import it.univaq.webengineering.soccorsoweb.service.SquadraService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController("squadraApiController")
@RequestMapping("/swa/api/squadre")
@RequiredArgsConstructor
public class SquadraController {

    private final SquadraService squadraService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public List<SquadraResponse> getAll() {
        return squadraService.getAll();
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public SquadraResponse getById(@PathVariable Long id) {
        return squadraService.getById(id);
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<SquadraResponse> create(@Valid @RequestBody SquadraRequest request) {
        SquadraResponse created = squadraService.create(request);
        return ResponseEntity.created(URI.create("/swa/api/squadre/" + created.getId())).body(created);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        squadraService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
