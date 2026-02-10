package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.MissioneMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.MissioneRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.MissioneUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MissioneResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.*;
import it.univaq.webengineering.soccorsoweb.repository.*;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@Data
@Service
public class MissioneService {

    private final MissioneRepository missioneRepository;
    private final MissioneMapper missioneMapper;
    private final RichiestaSoccorsoRepository richiestaSoccorsoRepository;
    private final RichiestaService richiestaService;
    private final UserRepository userRepository;
    private final CaposquadraRepository caposquadraRepository;
    private final SquadraRepository squadraRepository;
    private final MezzoRepository mezzoRepository;
    private final MaterialeRepository materialeRepository;
    private final AggiornamentoMissioneRepository aggiornamentoMissioneRepository;
    private final EmailService emailService;

    // =============================================
    // OPERAZIONI CRUD
    // =============================================

    /**
     * Crea una nuova missione assegnando caposquadra, operatori, mezzi e materiali.
     * Crea automaticamente una Squadra associata.
     */
    @Transactional
    public MissioneResponse inserisciMissione(@Valid MissioneRequest request) {

        // 1. Recupera le entità principali
        Caposquadra caposquadra = trovaCaposquadra(request.getCaposquadraId());
        RichiestaSoccorso richiesta = richiestaSoccorsoRepository.findById(request.getRichiestaId())
                .orElseThrow(() -> new EntityNotFoundException("Richiesta non trovata: " + request.getRichiestaId()));

        // 2. Crea la missione
        Missione missione = missioneMapper.toEntity(request);
        missione.setCaposquadra(caposquadra);
        missione.setRichiesta(richiesta);
        missione.setLatitudine(richiesta.getLatitudine());
        missione.setLongitudine(richiesta.getLongitudine());

        // 3. Crea la squadra real-time
        Squadra squadra = creaSquadraPerMissione(caposquadra, richiesta);
        missione.setSquadra(squadra);

        // 4. Assegna operatori (missione + squadra)
        List<User> operatori = assegnaOperatori(missione, request.getOperatoriIds());
        popolaSquadraConOperatori(squadra, operatori);

        // 5. Assegna mezzi (li rende indisponibili)
        assegnaMezzi(missione, request.getMezziIds());

        // 6. Assegna materiali (riduce le quantità)
        assegnaMateriali(missione, request.getMateriali());

        // 7. Salva e aggiorna stato richiesta
        Missione salvata = missioneRepository.save(missione);
        richiesta.setStato(RichiestaSoccorso.StatoRichiesta.IN_CORSO);
        richiestaSoccorsoRepository.save(richiesta);

        // 8. Notifiche email (caposquadra + operatori)
        notificaCaposquadra(salvata);
        notificaOperatori(salvata);

        return missioneMapper.toResponse(salvata);
    }

    /**
     * Aggiorna parzialmente una missione (PATCH).
     * Gestisce cambio stato, chiusura risorse, aggiornamento operatori.
     */
    @Transactional
    public MissioneResponse aggiornaMissione(Long id, MissioneUpdateRequest request) {
        Missione missione = trovaMissione(id);

        log.info("🔍 DEBUG aggiornaMissione id={} - stato={}, livelloSuccesso={}, commentiFinali={}",
                id, request.getStato(), request.getLivelloSuccesso(), request.getCommentiFinali());

        // Aggiorna campi semplici (solo se presenti nella request)
        if (request.getObiettivo() != null)
            missione.setObiettivo(request.getObiettivo());
        if (request.getPosizione() != null)
            missione.setPosizione(request.getPosizione());
        if (request.getLatitudine() != null)
            missione.setLatitudine(request.getLatitudine());
        if (request.getLongitudine() != null)
            missione.setLongitudine(request.getLongitudine());
        if (request.getCommentiFinali() != null)
            missione.setCommentiFinali(request.getCommentiFinali());
        if (request.getLivelloSuccesso() != null)
            missione.setLivelloSuccesso(request.getLivelloSuccesso());

        // Cambio caposquadra
        if (request.getCaposquadraId() != null) {
            missione.setCaposquadra(trovaCaposquadra(request.getCaposquadraId()));
        }

        // Cambio stato → gestisce chiusura risorse
        if (request.getStato() != null) {
            Missione.StatoMissione nuovoStato = Missione.StatoMissione.valueOf(request.getStato().toUpperCase());
            missione.setStato(nuovoStato);

            if (missioneTerminata(nuovoStato)) {
                terminaMissione(missione, nuovoStato);
            }
        }

        // Sostituzione operatori
        if (request.getOperatoriIds() != null) {
            sostituisciOperatori(missione, request.getOperatoriIds());
        }

        // Gestione aggiornamenti testuali
        if (request.getAggiornamenti() != null && !request.getAggiornamenti().isEmpty()) {
            // Recupera l'admin loggato per associarlo all'aggiornamento
            String emailAdmin = org.springframework.security.core.context.SecurityContextHolder
                    .getContext().getAuthentication().getName();
            User admin = userRepository.findByEmail(emailAdmin)
                    .orElseThrow(() -> new jakarta.persistence.EntityNotFoundException(
                            "Utente admin non trovato: " + emailAdmin));

            for (MissioneUpdateRequest.AggiornamentoEntry entry : request.getAggiornamenti()) {
                if (entry.getDescrizione() != null && !entry.getDescrizione().isBlank()) {
                    AggiornamentoMissione agg = AggiornamentoMissione.builder()
                            .missione(missione)
                            .admin(admin)
                            .descrizione(entry.getDescrizione())
                            .build();
                    aggiornamentoMissioneRepository.save(agg);

                    // Notifica tutti i membri della squadra
                    notificaAggiornamentoATuttiIMembri(missione, entry.getDescrizione());
                }
            }
        }

        missione.setUpdatedAt(LocalDateTime.now());
        Missione salvata = missioneRepository.save(missione);

        notificaOperatori(salvata);
        return missioneMapper.toResponse(salvata);
    }

    /**
     * Modifica lo stato di una missione (endpoint semplificato).
     */
    @Transactional
    public MissioneResponse modificaMissione(Long id, String nuovoStato) {
        Missione missione = trovaMissione(id);

        Missione.StatoMissione stato;
        try {
            stato = Missione.StatoMissione.valueOf(nuovoStato.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(
                    "Stato non valido: " + nuovoStato + ". Valori: IN_CORSO, CHIUSA, FALLITA");
        }

        missione.setStato(stato);
        missione.setUpdatedAt(LocalDateTime.now());

        if (missioneTerminata(stato)) {
            terminaMissione(missione, stato);
        }

        return missioneMapper.toResponse(missioneRepository.save(missione));
    }

    /**
     * Chiude direttamente una missione (endpoint dedicato).
     */
    @Transactional
    public MissioneResponse chiudiMissione(Long id) {
        Missione missione = trovaMissione(id);
        missione.setStato(Missione.StatoMissione.CHIUSA);
        terminaMissione(missione, Missione.StatoMissione.CHIUSA);
        richiestaService.modificaRichiesta(missione.getRichiesta().getId(), "CHIUSA");
        return missioneMapper.toResponse(missioneRepository.save(missione));
    }

    /**
     * Elimina una missione e ripristina lo stato della richiesta.
     */
    @Transactional
    public void eliminaMissione(Long id) {
        Missione missione = trovaMissione(id);
        RichiestaSoccorso richiesta = missione.getRichiesta();
        if (richiesta != null) {
            richiesta.setStato(RichiestaSoccorso.StatoRichiesta.ATTIVA);
        }
        missioneRepository.deleteById(id);
    }

    // =============================================
    // QUERY (sola lettura)
    // =============================================

    @Transactional(readOnly = true)
    public MissioneResponse dettagliMissione(Long id) {
        return missioneMapper.toResponse(trovaMissione(id));
    }

    @Transactional(readOnly = true)
    public List<MissioneResponse> missioniOperatore(Long id) {
        return missioneMapper.toResponseList(missioneRepository.findAllByOperatoreId(id));
    }

    @Transactional(readOnly = true)
    public List<MissioneResponse> tutteLeMissioni() {
        return missioneMapper.toResponseList(missioneRepository.findAll());
    }

    // =============================================
    // METODI PRIVATI - Ricerca entità
    // =============================================

    private Missione trovaMissione(Long id) {
        return missioneRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Missione non trovata: " + id));
    }

    /**
     * Cerca il caposquadra per user ID.
     * Se l'utente esiste ma non ha un record caposquadra, lo crea automaticamente.
     */
    private Caposquadra trovaCaposquadra(Long userId) {
        return caposquadraRepository.findByUtenteId(userId)
                .orElseGet(() -> {
                    // L'utente esiste ma non è ancora registrato come caposquadra → lo crea
                    User utente = userRepository.findById(userId)
                            .orElseThrow(() -> new EntityNotFoundException("Utente non trovato: " + userId));
                    Caposquadra nuovoCapo = new Caposquadra();
                    nuovoCapo.setUtente(utente);
                    return caposquadraRepository.save(nuovoCapo);
                });
    }

    // =============================================
    // METODI PRIVATI - Creazione risorse
    // =============================================

    /**
     * Crea una Squadra associata alla missione corrente.
     */
    private Squadra creaSquadraPerMissione(Caposquadra caposquadra, RichiestaSoccorso richiesta) {
        Squadra squadra = Squadra.builder()
                .nome("Squadra Missione #" + richiesta.getId())
                .descrizione("Squadra per richiesta #" + richiesta.getId())
                .caposquadra(caposquadra)
                .attiva(true)
                .build();
        return squadraRepository.save(squadra);
    }

    /**
     * Assegna operatori alla missione e restituisce la lista.
     */
    private List<User> assegnaOperatori(Missione missione, Set<Long> operatoriIds) {
        if (operatoriIds == null || operatoriIds.isEmpty()) {
            missione.setMissioneOperatori(new HashSet<>());
            return List.of();
        }

        List<User> operatori = userRepository.findAllById(operatoriIds);
        Set<MissioneOperatore> missioneOperatori = new HashSet<>();

        for (User operatore : operatori) {
            MissioneOperatore mo = new MissioneOperatore();
            mo.setId(new MissioneOperatore.MissioneOperatoreId(null, operatore.getId()));
            mo.setMissione(missione);
            mo.setOperatore(operatore);
            mo.setAssegnatoAt(LocalDateTime.now());
            missioneOperatori.add(mo);
        }

        missione.setMissioneOperatori(missioneOperatori);
        return operatori;
    }

    /**
     * Popola la squadra con gli operatori assegnati.
     */
    private void popolaSquadraConOperatori(Squadra squadra, List<User> operatori) {
        if (operatori.isEmpty())
            return;

        Set<SquadraOperatore> squadraOperatori = new HashSet<>();
        for (User operatore : operatori) {
            SquadraOperatore so = SquadraOperatore.builder()
                    .id(new SquadraOperatore.SquadraOperatoreId(squadra.getId(), operatore.getId()))
                    .squadra(squadra)
                    .operatore(operatore)
                    .ruolo("OPERATORE")
                    .assegnatoIl(LocalDate.now())
                    .build();
            squadraOperatori.add(so);
        }

        squadra.setOperatori(squadraOperatori);
        squadraRepository.save(squadra);
    }

    /**
     * Assegna mezzi alla missione e li rende indisponibili.
     */
    private void assegnaMezzi(Missione missione, Set<Long> mezziIds) {
        if (mezziIds == null || mezziIds.isEmpty())
            return;

        Set<MissioneMezzo> missioneMezzi = new HashSet<>();
        List<Mezzo> mezzi = mezzoRepository.findAllById(mezziIds);

        for (Mezzo mezzo : mezzi) {
            mezzo.setDisponibile(false);
            MissioneMezzo mm = new MissioneMezzo();
            mm.setId(new MissioneMezzo.MissioneMezzoId());
            mm.setMissione(missione);
            mm.setMezzo(mezzo);
            missioneMezzi.add(mm);
        }

        missione.setMissioniMezzi(missioneMezzi);
    }

    /**
     * Assegna materiali alla missione e decrementa le quantità.
     */
    private void assegnaMateriali(Missione missione, Set<MissioneRequest.MissioneMaterialeAssignment> materialiReq) {
        if (materialiReq == null || materialiReq.isEmpty())
            return;

        Set<MissioneMateriale> missioneMateriali = new HashSet<>();

        for (MissioneRequest.MissioneMaterialeAssignment ma : materialiReq) {
            Materiale mat = materialeRepository.findById(ma.getMaterialeId())
                    .orElseThrow(() -> new EntityNotFoundException("Materiale non trovato: " + ma.getMaterialeId()));

            if (mat.getQuantita() < ma.getQuantitaUsata()) {
                throw new IllegalArgumentException("Quantità insufficiente per: " + mat.getNome());
            }

            mat.setQuantita(mat.getQuantita() - ma.getQuantitaUsata());
            if (mat.getQuantita() <= 0) {
                mat.setDisponibile(false);
            }

            MissioneMateriale mm = new MissioneMateriale();
            mm.setId(new MissioneMateriale.MissioneMaterialeId());
            mm.setMissione(missione);
            mm.setMateriale(mat);
            mm.setQuantitaUsata(ma.getQuantitaUsata());
            missioneMateriali.add(mm);
        }

        missione.setMissioniMateriali(missioneMateriali);
    }

    // =============================================
    // METODI PRIVATI - Terminazione missione
    // =============================================

    /**
     * Controlla se lo stato rappresenta una missione terminata.
     */
    private boolean missioneTerminata(Missione.StatoMissione stato) {
        return stato == Missione.StatoMissione.CHIUSA || stato == Missione.StatoMissione.FALLITA;
    }

    /**
     * Gestisce tutta la logica di terminazione:
     * - Imposta data fine
     * - Rilascia mezzi
     * - Disattiva squadra
     * - Aggiorna stato richiesta
     */
    private void terminaMissione(Missione missione, Missione.StatoMissione stato) {
        missione.setFineAt(LocalDateTime.now());

        // Rilascio mezzi
        if (missione.getMissioniMezzi() != null) {
            for (MissioneMezzo mm : missione.getMissioniMezzi()) {
                mm.getMezzo().setDisponibile(true);
            }
        }

        // Disattiva squadra
        if (missione.getSquadra() != null) {
            missione.getSquadra().setAttiva(false);
        }

        // Aggiorna richiesta soccorso
        RichiestaSoccorso richiesta = missione.getRichiesta();
        if (richiesta != null) {
            richiesta.setStato(
                    stato == Missione.StatoMissione.CHIUSA
                            ? RichiestaSoccorso.StatoRichiesta.CHIUSA
                            : RichiestaSoccorso.StatoRichiesta.IGNORATA);
        }
    }

    // =============================================
    // METODI PRIVATI - Aggiornamento operatori
    // =============================================

    /**
     * Sostituisce completamente gli operatori di una missione.
     */
    private void sostituisciOperatori(Missione missione, Set<Long> nuoviIds) {
        missione.getMissioneOperatori().clear();

        if (nuoviIds.isEmpty())
            return;

        List<User> operatori = userRepository.findAllById(nuoviIds);
        for (User operatore : operatori) {
            MissioneOperatore mo = new MissioneOperatore();
            mo.setId(new MissioneOperatore.MissioneOperatoreId(missione.getId(), operatore.getId()));
            mo.setMissione(missione);
            mo.setOperatore(operatore);
            mo.setAssegnatoAt(LocalDateTime.now());
            missione.getMissioneOperatori().add(mo);
        }
    }

    // =============================================
    // METODI PRIVATI - Notifiche
    // =============================================

    /**
     * Notifica il caposquadra dell'assegnazione alla missione.
     */
    private void notificaCaposquadra(Missione missione) {
        if (missione.getCaposquadra() == null || missione.getCaposquadra().getUtente() == null)
            return;

        try {
            emailService.inviaNotificaMissione(missione.getCaposquadra().getUtente(), missione);
        } catch (Exception e) {
            log.error("Errore notifica caposquadra {}: {}",
                    missione.getCaposquadra().getUtente().getEmail(), e.getMessage());
        }
    }

    /**
     * Notifica via email gli operatori non ancora notificati.
     */
    private void notificaOperatori(Missione missione) {
        if (missione.getMissioneOperatori() == null)
            return;

        for (MissioneOperatore mo : missione.getMissioneOperatori()) {
            if (mo.getNotificatoAt() != null)
                continue;

            try {
                emailService.inviaNotificaMissione(mo.getOperatore(), missione);
                mo.setNotificatoAt(LocalDateTime.now());
            } catch (Exception e) {
                log.error("Errore notifica operatore {}: {}", mo.getOperatore().getEmail(), e.getMessage());
            }
        }
    }

    /**
     * Notifica tutti i membri della squadra (caposquadra + operatori) di un
     * aggiornamento.
     */
    private void notificaAggiornamentoATuttiIMembri(Missione missione, String testoAggiornamento) {
        // Notifica caposquadra
        if (missione.getCaposquadra() != null && missione.getCaposquadra().getUtente() != null) {
            try {
                emailService.inviaNotificaAggiornamento(
                        missione.getCaposquadra().getUtente(), missione, testoAggiornamento);
            } catch (Exception e) {
                log.error("Errore notifica aggiornamento caposquadra: {}", e.getMessage());
            }
        }

        // Notifica operatori
        if (missione.getMissioneOperatori() != null) {
            for (MissioneOperatore mo : missione.getMissioneOperatori()) {
                try {
                    emailService.inviaNotificaAggiornamento(
                            mo.getOperatore(), missione, testoAggiornamento);
                } catch (Exception e) {
                    log.error("Errore notifica aggiornamento operatore {}: {}",
                            mo.getOperatore().getEmail(), e.getMessage());
                }
            }
        }
    }
}
