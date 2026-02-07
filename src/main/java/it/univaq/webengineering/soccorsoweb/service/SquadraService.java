package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.SquadraMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.SquadraRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.SquadraResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Caposquadra;
import it.univaq.webengineering.soccorsoweb.model.entity.Squadra;
import it.univaq.webengineering.soccorsoweb.repository.CaposquadraRepository;
import it.univaq.webengineering.soccorsoweb.repository.SquadraRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SquadraService {

    private final SquadraRepository squadraRepository;
    private final CaposquadraRepository caposquadraRepository;
    private final SquadraMapper squadraMapper;

    public List<SquadraResponse> getAll() {
        return squadraMapper.toResponseList(squadraRepository.findAll());
    }

    public SquadraResponse getById(Long id) {
        Squadra squadra = squadraRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Squadra non trovata: " + id));
        return squadraMapper.toResponse(squadra);
    }

    @Transactional
    public SquadraResponse create(SquadraRequest request) {
        Squadra squadra = squadraMapper.toEntity(request);

        if (request.getCaposquadraId() != null) {
            Caposquadra caposquadra = caposquadraRepository.findByUtenteId(request.getCaposquadraId())
                    .orElseThrow(() -> new EntityNotFoundException(
                            "Caposquadra non trovato per utente ID: " + request.getCaposquadraId()));
            squadra.setCaposquadra(caposquadra);
        } else {
            throw new IllegalArgumentException("Caposquadra obbligatorio");
        }

        squadra = squadraRepository.save(squadra);
        return squadraMapper.toResponse(squadra);
    }

    @Transactional
    public void delete(Long id) {
        if (!squadraRepository.existsById(id)) {
            throw new EntityNotFoundException("Squadra non trovata: " + id);
        }
        squadraRepository.deleteById(id);
    }
}
