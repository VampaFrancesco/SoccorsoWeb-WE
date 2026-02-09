package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.AbilitaMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.AbilitaRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.AbilitaResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Abilita;
import it.univaq.webengineering.soccorsoweb.repository.AbilitaRepository;
import it.univaq.webengineering.soccorsoweb.swa.api.AbilitaController;
import lombok.Data;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpClientErrorException.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.stream.Collectors;

@Data
@Service
public class AbilitaService {

    public final AbilitaRepository abilitaRepository;
    public final AbilitaMapper abilitaMapper;

    public List<AbilitaResponse> getAllAbilita() {
        return abilitaRepository.findAll().stream()
                .map(abilitaMapper::toResponse)
                .collect(Collectors.toList());
    }

    public AbilitaResponse creaAbilita(AbilitaRequest request) {
        //Se esiste -> errore 409
        if (abilitaRepository.findByNome(request.getNome()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Un'abilità con questo nome esiste già");
        }
        Abilita abilita = abilitaMapper.toEntity(request);
        Abilita saved = abilitaRepository.save(abilita);
        return abilitaMapper.toResponse(saved);
    }
}
