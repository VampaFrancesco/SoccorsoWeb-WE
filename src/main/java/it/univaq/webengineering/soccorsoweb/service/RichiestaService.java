package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.RichiestaSoccorsoMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.RichiestaSoccorsoRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.RichiestaSoccorsoUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.RichiestaSoccorsoResponse;
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
import java.util.UUID;

@Slf4j
@Service
public class RichiestaService {

    private final RichiestaSoccorsoMapper richiestaSoccorsoMapper;
    private final RichiestaSoccorsoRepository richiestaSoccorsoRepository;
    private final MissioneRepository missioneRepository;
    private final EmailService emailService;

    private final String baseUrl = "http://localhost:8080";

    /** Numero massimo di richieste per IP nella finestra temporale */
    @Value("${soccorsoweb.rate-limit.max-requests:5}")
    private int maxRequestsPerIp;

    /** Finestra temporale in minuti per il rate limiting */
    @Value("${soccorsoweb.rate-limit.window-minutes:60}")
    private int rateLimitWindowMinutes;

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

        // 0. Rate limiting anti-spam per IP
        String clientIp = getClientIp(request);
        verificaRateLimitIp(clientIp);

        // 1. Crea e salva richiesta nel DB
        RichiestaSoccorso richiesta = richiestaSoccorsoMapper.toEntity(richiestaSoccorsoRequest);
        richiesta.setIpOrigine(clientIp);
        richiesta.setTokenConvalida(UUID.randomUUID().toString());
        richiesta.setStato(null); // Stato vuoto fino alla convalida email

        RichiestaSoccorso richiestaSalvata = richiestaSoccorsoRepository.save(richiesta);

        try {
            String linkConvalida = baseUrl +
                    "/convalida?token_convalida=" +
                    richiestaSalvata.getTokenConvalida();

            emailService.inviaEmailConvalida(
                    richiestaSalvata.getEmailSegnalante(),
                    richiestaSalvata.getNomeSegnalante(),
                    linkConvalida);

            log.info("Email di convalida inviata a: {}", richiestaSalvata.getEmailSegnalante());

        } catch (Exception e) {
            log.error("⚠Impossibile inviare email di convalida a {}: {}",
                    richiestaSalvata.getEmailSegnalante(), e.getMessage());
            log.error("Stack trace completo: ", e);
        }

        // 3. Restituisci risposta (SEMPRE successo, anche se email fallisce)
        return richiestaSoccorsoMapper.toResponse(richiestaSalvata);
    }

    public void convalidaRichiesta(String token) throws EntityNotFoundException {
        RichiestaSoccorso richiesta = richiestaSoccorsoRepository.findByTokenConvalida(token);

        if (richiesta == null) {
            throw new EntityNotFoundException("Token di convalida non valido o già utilizzato.");
        }

        // Verifica se già convalidata (doppia sicurezza)
        if (richiesta.getConvalidataAt() != null) {
            throw new IllegalStateException("Questa richiesta è già stata convalidata.");
        }

        richiesta.setStato(RichiestaSoccorso.StatoRichiesta.ATTIVA);
        richiesta.setConvalidataAt(LocalDateTime.now());
        richiesta.setUpdatedAt(LocalDateTime.now());

        // Invalida il token → one-time use
        richiesta.setTokenConvalida(null);

        richiestaSoccorsoRepository.save(richiesta);
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

    /**
     * Verifica che l'IP non abbia superato il limite di richieste nella finestra
     * temporale.
     * Lancia un'eccezione se il limite è stato raggiunto.
     */
    private void verificaRateLimitIp(String ip) {
        LocalDateTime finestraInizio = LocalDateTime.now().minusMinutes(rateLimitWindowMinutes);
        long count = richiestaSoccorsoRepository.countByIpOrigineAndCreatedAtAfter(ip, finestraInizio);

        if (count >= maxRequestsPerIp) {
            log.warn("⚠️ Rate limit raggiunto per IP: {} ({} richieste in {} minuti)", ip, count,
                    rateLimitWindowMinutes);
            throw new IllegalStateException(
                    String.format("Hai raggiunto il limite massimo di %d richieste in %d minuti. Riprova più tardi.",
                            maxRequestsPerIp, rateLimitWindowMinutes));
        }
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
