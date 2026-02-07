package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.RichiestaSoccorsoMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.RichiestaSoccorsoRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.RichiestaSoccorsoUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.RichiestaSoccorsoResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Missione;
import it.univaq.webengineering.soccorsoweb.model.entity.RichiestaSoccorso;
import it.univaq.webengineering.soccorsoweb.repository.MissioneRepository;
import it.univaq.webengineering.soccorsoweb.repository.RichiestaSoccorsoRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
public class RichiestaService {

    private final RichiestaSoccorsoMapper richiestaSoccorsoMapper;
    private final RichiestaSoccorsoRepository richiestaSoccorsoRepository;
    private final MissioneRepository missioneRepository;
    private final EmailService emailService;

    private final String baseUrl = "http://localhost:8080";

    public RichiestaService(RichiestaSoccorsoMapper richiestaSoccorsoMapper,
            RichiestaSoccorsoRepository richiestaSoccorsoRepository,
            MissioneRepository missioneRepository,
            EmailService emailService) {
        this.richiestaSoccorsoMapper = richiestaSoccorsoMapper;
        this.richiestaSoccorsoRepository = richiestaSoccorsoRepository;
        this.missioneRepository = missioneRepository;
        this.emailService = emailService;
    }

    @Transactional
    public RichiestaSoccorsoResponse nuovaRichiesta(RichiestaSoccorsoRequest richiestaSoccorsoRequest,
            HttpServletRequest request) {
        // 1. Crea e salva richiesta nel DB
        RichiestaSoccorso richiesta = richiestaSoccorsoMapper.toEntity(richiestaSoccorsoRequest);
        richiesta.setIpOrigine(getClientIp(request));
        richiesta.setTokenConvalida(UUID.randomUUID().toString());

        RichiestaSoccorso richiestaSalvata = richiestaSoccorsoRepository.save(richiesta);

        try {
            String linkConvalida = baseUrl +
                    "/convalida?token_convalida=" +
                    richiestaSalvata.getTokenConvalida();

            emailService.inviaEmailConvalida(
                    richiestaSalvata.getEmailSegnalante(),
                    richiestaSalvata.getNomeSegnalante(),
                    linkConvalida);

            log.info("✅ Email di convalida inviata a: {}", richiestaSalvata.getEmailSegnalante());

        } catch (Exception e) {
            log.error("⚠️ Impossibile inviare email di convalida a {}: {}",
                    richiestaSalvata.getEmailSegnalante(), e.getMessage());
            log.error("Stack trace completo: ", e);
        }

        // 3. Restituisci risposta (SEMPRE successo, anche se email fallisce)
        return richiestaSoccorsoMapper.toResponse(richiestaSalvata);
    }

    public boolean convalidaRichiesta(String token) throws EntityNotFoundException {
        RichiestaSoccorso richiesta = richiestaSoccorsoRepository.findByTokenConvalida(token);

        if (richiesta == null) {
            throw new EntityNotFoundException("Token di convalida non valido.");
        }

        richiesta.setStato(RichiestaSoccorso.StatoRichiesta.ATTIVA);
        richiesta.setConvalidataAt(LocalDateTime.now());
        richiesta.setUpdatedAt(LocalDateTime.now());
        richiestaSoccorsoRepository.save(richiesta);
        return true;
    }

    public Page<RichiestaSoccorsoResponse> richiesteFiltrate(String stato, Pageable pageable) {
        Page<RichiestaSoccorso> richiesteEntity;

        if ("TUTTE".equalsIgnoreCase(stato)) {
            richiesteEntity = richiestaSoccorsoRepository.findAll(pageable);
        } else {
            RichiestaSoccorso.StatoRichiesta statoEnum = RichiestaSoccorso.StatoRichiesta.valueOf(stato.toUpperCase());
            richiesteEntity = richiestaSoccorsoRepository.findByStato(statoEnum, pageable);
        }

        return richiesteEntity.map(richiestaSoccorsoMapper::toResponse);
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");

        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }

        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }

        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }

    public void eliminaRichiesta(Long id) {
        richiestaSoccorsoRepository.deleteById(id);
    }

    public RichiestaSoccorsoResponse modificaRichiesta(Long id, String nuovoStato) {
        RichiestaSoccorso richiesta = richiestaSoccorsoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Richiesta non trovata con ID: " + id));
        RichiestaSoccorso.StatoRichiesta statoEnum = RichiestaSoccorso.StatoRichiesta.valueOf(nuovoStato.toUpperCase());
        richiesta.setStato(statoEnum);
        richiesta.setUpdatedAt(LocalDateTime.now());
        RichiestaSoccorso richiestaAggiornata = richiestaSoccorsoRepository.save(richiesta);
        return richiestaSoccorsoMapper.toResponse(richiestaAggiornata);
    }

    public RichiestaSoccorsoResponse dettagliRichiesta(Long id) {
        RichiestaSoccorso richiesta = richiestaSoccorsoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Richiesta non trovata con ID: " + id));
        return richiestaSoccorsoMapper.toResponse(richiesta);
    }

    public RichiestaSoccorsoResponse annullaRichiesta(Long id) {
        RichiestaSoccorso richiesta = richiestaSoccorsoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Richiesta non trovata con ID: " + id));
        richiesta.setStato(RichiestaSoccorso.StatoRichiesta.IGNORATA);
        richiesta.setUpdatedAt(LocalDateTime.now());
        RichiestaSoccorso richiestaAggiornata = richiestaSoccorsoRepository.save(richiesta);
        return richiestaSoccorsoMapper.toResponse(richiestaAggiornata);
    }

    @Transactional
    public RichiestaSoccorsoResponse aggiornaRichiesta(Long id, RichiestaSoccorsoUpdateRequest updateRequest) {
        RichiestaSoccorso richiesta = richiestaSoccorsoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Richiesta non trovata con ID: " + id));

        if (updateRequest.getDescrizione() != null) {
            richiesta.setDescrizione(updateRequest.getDescrizione());
        }
        if (updateRequest.getIndirizzo() != null) {
            richiesta.setIndirizzo(updateRequest.getIndirizzo());
        }
        if (updateRequest.getLatitudine() != null) {
            richiesta.setLatitudine(updateRequest.getLatitudine());
        }
        if (updateRequest.getLongitudine() != null) {
            richiesta.setLongitudine(updateRequest.getLongitudine());
        }
        if (updateRequest.getNomeSegnalante() != null) {
            richiesta.setNomeSegnalante(updateRequest.getNomeSegnalante());
        }
        if (updateRequest.getEmailSegnalante() != null) {
            richiesta.setEmailSegnalante(updateRequest.getEmailSegnalante());
        }
        if (updateRequest.getFoto() != null && updateRequest.getFoto().length > 0) {
            try {
                richiesta.setFoto(new javax.sql.rowset.serial.SerialBlob(updateRequest.getFoto()));
            } catch (java.sql.SQLException e) {
                throw new RuntimeException("Errore conversione foto in Blob", e);
            }
        }
        if (updateRequest.getTelefonoSegnalante() != null) {
            richiesta.setTelefonoSegnalante(updateRequest.getTelefonoSegnalante());
        }
        if (updateRequest.getStato() != null) {
            RichiestaSoccorso.StatoRichiesta statoEnum = RichiestaSoccorso.StatoRichiesta
                    .valueOf(updateRequest.getStato().toUpperCase());
            richiesta.setStato(statoEnum);
        }
        richiesta.setUpdatedAt(LocalDateTime.now());
        RichiestaSoccorso richiestaAggiornata = richiestaSoccorsoRepository.save(richiesta);
        return richiestaSoccorsoMapper.toResponse(richiestaAggiornata);
    }
}
