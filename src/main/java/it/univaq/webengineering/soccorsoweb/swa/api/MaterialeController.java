package it.univaq.webengineering.soccorsoweb.swa.api;

import it.univaq.webengineering.soccorsoweb.model.dto.request.MaterialeRequest;
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
    @PreAuthorize("hasAnyRole('ADMIN')")
    public List<MaterialeResponse> getAll() {
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
}
