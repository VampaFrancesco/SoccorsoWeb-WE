package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.MezzoRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MezzoResponse;
import it.univaq.webengineering.soccorsoweb.service.MezzoService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController("mezzoApiController")
@RequestMapping("/swa/api/mezzi")
@RequiredArgsConstructor
public class MezzoController {

    private final MezzoService mezzoService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public List<MezzoResponse> getAll(@RequestParam(required = false) Boolean disponibile) {
        if (Boolean.TRUE.equals(disponibile)) {
            return mezzoService.getDisponibili();
        }
        return mezzoService.getAll();
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public MezzoResponse getById(@PathVariable Long id) {
        return mezzoService.getById(id);
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public ResponseEntity<MezzoResponse> create(@Valid @RequestBody MezzoRequest request) {
        MezzoResponse created = mezzoService.create(request);
        return ResponseEntity.created(URI.create("/swa/api/mezzi/" + created.getId())).body(created);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        mezzoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/disponibilita")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public MezzoResponse toggleDisponibilita(@PathVariable Long id) {
        return mezzoService.toggleDisponibilita(id);
    }
}
