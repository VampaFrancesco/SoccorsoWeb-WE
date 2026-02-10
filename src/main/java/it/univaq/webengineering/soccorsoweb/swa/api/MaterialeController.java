package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.MaterialeRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.ModificaQuantitaRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MaterialeResponse;
import it.univaq.webengineering.soccorsoweb.service.MaterialeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController("materialeApiController")
@RequestMapping("/swa/api/materiali")
@RequiredArgsConstructor
public class MaterialeController {

    private final MaterialeService materialeService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATORE')")
    public List<MaterialeResponse> getAll(@RequestParam(required = false) Boolean disponibile) {
        if (Boolean.TRUE.equals(disponibile)) {
            return materialeService.getDisponibili();
        }
        return materialeService.getAll();
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public MaterialeResponse getById(@PathVariable Long id) {
        return materialeService.getById(id);
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN')")
    public ResponseEntity<MaterialeResponse> create(@Valid @RequestBody MaterialeRequest request) {
        MaterialeResponse created = materialeService.create(request);
        return ResponseEntity.created(URI.create("/swa/api/materiali/" + created.getId())).body(created);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        materialeService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/quantita")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<MaterialeResponse> updateQuantita(
            @PathVariable Long id,
            @Valid @RequestBody ModificaQuantitaRequest request) {
        MaterialeResponse updated = materialeService.updateQuantita(id, request.getQuantita());
        return ResponseEntity.ok(updated);
    }

    @PatchMapping("/{id}/toggle-disponibilita")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<MaterialeResponse> toggleDisponibilita(@PathVariable Long id) {
        MaterialeResponse updated = materialeService.toggleDisponibilita(id);
        return ResponseEntity.ok(updated);
    }
}
