package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.model.dto.request.PatenteRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.PatenteResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Patente;
import it.univaq.webengineering.soccorsoweb.repository.PatenteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PatenteService {

    private final PatenteRepository patenteRepository;

    public List<PatenteResponse> getAllPatenti() {
        return patenteRepository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public PatenteResponse creaPatente(PatenteRequest request) {
        if (patenteRepository.findByTipo(request.getTipo()).isPresent()) {
            throw new IllegalArgumentException("Esiste già una patente di tipo: " + request.getTipo());
        }

        Patente patente = Patente.builder()
                .tipo(request.getTipo())
                .descrizione(request.getDescrizione())
                .build();

        return toResponse(patenteRepository.save(patente));
    }

    private PatenteResponse toResponse(Patente patente) {
        return PatenteResponse.builder()
                .id(patente.getId())
                .tipo(patente.getTipo())
                .descrizione(patente.getDescrizione())
                .build();
    }
}
