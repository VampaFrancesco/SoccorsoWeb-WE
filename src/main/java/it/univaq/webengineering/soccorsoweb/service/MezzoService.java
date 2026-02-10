package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.MezzoMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.MezzoRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MezzoResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Mezzo;
import it.univaq.webengineering.soccorsoweb.repository.MezzoRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MezzoService {

    private final MezzoRepository mezzoRepository;
    private final MezzoMapper mezzoMapper;

    public List<MezzoResponse> getAll() {
        return mezzoMapper.toResponseList(mezzoRepository.findAll());
    }

    public List<MezzoResponse> getDisponibili() {
        return mezzoMapper.toResponseList(mezzoRepository.findByDisponibileTrue());
    }

    public MezzoResponse getById(Long id) {
        Mezzo mezzo = mezzoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Mezzo non trovato: " + id));
        return mezzoMapper.toResponse(mezzo);
    }

    @Transactional
    public MezzoResponse create(MezzoRequest request) {
        Mezzo mezzo = mezzoMapper.toEntity(request);
        mezzo = mezzoRepository.save(mezzo);
        return mezzoMapper.toResponse(mezzo);
    }

    @Transactional
    public void delete(Long id) {
        if (!mezzoRepository.existsById(id)) {
            throw new EntityNotFoundException("Mezzo non trovato: " + id);
        }
        mezzoRepository.deleteById(id);
    }

    @Transactional
    public MezzoResponse toggleDisponibilita(Long id) {
        Mezzo mezzo = mezzoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Mezzo non trovato: " + id));

        // Use standard boolean logic allowing for nulls if existing data might be
        // dirty,
        // though database constraints suggest it shouldn't be null.
        // Assuming default is true, if null treat as false -> true.
        boolean current = Boolean.TRUE.equals(mezzo.getDisponibile());
        mezzo.setDisponibile(!current);

        mezzo = mezzoRepository.save(mezzo);
        return mezzoMapper.toResponse(mezzo);
    }
}
