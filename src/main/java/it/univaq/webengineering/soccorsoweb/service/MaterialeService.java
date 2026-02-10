package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.MaterialeMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.MaterialeRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MaterialeResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Materiale;
import it.univaq.webengineering.soccorsoweb.repository.MaterialeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MaterialeService {

    private final MaterialeRepository materialeRepository;
    private final MaterialeMapper materialeMapper;

    public List<MaterialeResponse> getAll() {
        return materialeMapper.toResponseList(materialeRepository.findAll());
    }

    public List<MaterialeResponse> getDisponibili() {
        return materialeMapper.toResponseList(materialeRepository.findByDisponibileTrue());
    }

    public MaterialeResponse getById(Long id) {
        Materiale materiale = materialeRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Materiale non trovato: " + id));
        return materialeMapper.toResponse(materiale);
    }

    @Transactional
    public MaterialeResponse create(MaterialeRequest request) {
        Materiale materiale = materialeMapper.toEntity(request);
        materiale = materialeRepository.save(materiale);
        return materialeMapper.toResponse(materiale);
    }

    @Transactional
    public void delete(Long id) {
        if (!materialeRepository.existsById(id)) {
            throw new EntityNotFoundException("Materiale non trovato: " + id);
        }
        materialeRepository.deleteById(id);
    }

    @Transactional
    public MaterialeResponse updateQuantita(Long id, Integer nuovaQuantita) {
        Materiale materiale = materialeRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Materiale non trovato: " + id));

        materiale.setQuantita(nuovaQuantita);
        // Aggiorna disponibilità in base alla quantità
        materiale.setDisponibile(nuovaQuantita > 0);

        materiale = materialeRepository.save(materiale);
        return materialeMapper.toResponse(materiale);
    }

    @Transactional
    public MaterialeResponse toggleDisponibilita(Long id) {
        Materiale materiale = materialeRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Materiale non trovato: " + id));

        materiale.setDisponibile(!materiale.getDisponibile());
        materiale = materialeRepository.save(materiale);
        return materialeMapper.toResponse(materiale);
    }
}
