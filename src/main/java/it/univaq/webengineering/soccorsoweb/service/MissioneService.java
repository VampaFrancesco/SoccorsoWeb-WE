package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.MissioneMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.MissioneRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.MissioneUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MissioneResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Caposquadra;
import it.univaq.webengineering.soccorsoweb.model.entity.Missione;
import it.univaq.webengineering.soccorsoweb.model.entity.MissioneOperatore;
import it.univaq.webengineering.soccorsoweb.model.entity.RichiestaSoccorso;
import it.univaq.webengineering.soccorsoweb.model.entity.User;
import it.univaq.webengineering.soccorsoweb.repository.CaposquadraRepository;
import it.univaq.webengineering.soccorsoweb.repository.MissioneRepository;
import it.univaq.webengineering.soccorsoweb.repository.RichiestaSoccorsoRepository;
import it.univaq.webengineering.soccorsoweb.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Transactional
    public MissioneResponse modificaMissione(Long id, String nuovoStato) {
        // Cerca la missione
        Missione missione = missioneRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Missione non trovata con ID: " + id));

        // Valida e converte lo stato
        Missione.StatoMissione statoMissione;
        try {
            statoMissione = Missione.StatoMissione.valueOf(nuovoStato.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Stato missione non valido: " + nuovoStato +
                    ". Valori ammessi: IN_CORSO, CHIUSA, FALLITA");
        }

        missione.setStato(statoMissione);
        missione.setUpdatedAt(LocalDateTime.now());

        // Se la missione viene chiusa o fallita, imposta anche la data di fine
        if (statoMissione == Missione.StatoMissione.CHIUSA || statoMissione == Missione.StatoMissione.FALLITA) {
            missione.setFineAt(LocalDateTime.now());

            // Aggiorna anche lo stato della richiesta
            RichiestaSoccorso richiesta = missione.getRichiesta();
            if (richiesta != null) {
                RichiestaSoccorso.StatoRichiesta statoRichiesta = statoMissione == Missione.StatoMissione.CHIUSA
                        ? RichiestaSoccorso.StatoRichiesta.CHIUSA
                        : RichiestaSoccorso.StatoRichiesta.IGNORATA;
                richiesta.setStato(statoRichiesta);
            }
        }

        Missione missioneSalvata = missioneRepository.save(missione);
        return missioneMapper.toResponse(missioneSalvata);
    }

    @Transactional
    public void eliminaMissione(Long id) {
        Missione missione = missioneRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Missione non trovata con ID: " + id));

        // Ripristina lo stato della richiesta
        RichiestaSoccorso richiesta = missione.getRichiesta();
        if (richiesta != null) {
            richiesta.setStato(RichiestaSoccorso.StatoRichiesta.ATTIVA); // Ripristina ad ATTIVA (ex Convalidata)
        }

        missioneRepository.deleteById(id);
    }

    @Transactional
    public MissioneResponse inserisciMissione(@Valid MissioneRequest missioneRequest) {

        // ottengo caposquadra
        Caposquadra caposquadra = caposquadraRepository.findByUtenteId(missioneRequest.getCaposquadraId())
                .orElseThrow(() -> new EntityNotFoundException(
                        "Caposquadra non trovato per utente ID: " + missioneRequest.getCaposquadraId()));

        // ottengo richiesta
        RichiestaSoccorso richiesta = richiestaSoccorsoRepository.findById(missioneRequest.getRichiestaId())
                .orElseThrow();

        // creo missione
        Missione missione = missioneMapper.toEntity(missioneRequest);
        missione.setLatitudine(richiesta.getLatitudine());
        missione.setLongitudine(richiesta.getLongitudine());

        // setto caposquadra e richiesta
        missione.setCaposquadra(caposquadra);
        missione.setRichiesta(richiesta);

        // gestisco operatori
        if (missioneRequest.getOperatoriIds() != null && !missioneRequest.getOperatoriIds().isEmpty()) {
            Set<MissioneOperatore> missioneOperatori = new HashSet<>();
            List<User> operatori = userRepository.findAllById(missioneRequest.getOperatoriIds());

            for (User operatore : operatori) {
                MissioneOperatore missioneOperatore = new MissioneOperatore();
                missioneOperatore.setOperatore(operatore);
                missioneOperatore.setMissione(missione);
                missioneOperatore.setAssegnatoAt(LocalDateTime.now()); // Setta timestamp
                MissioneOperatore.MissioneOperatoreId id = new MissioneOperatore.MissioneOperatoreId();
                id.setMissioneId(missione.getId());
                id.setOperatoreId(operatore.getId());
                missioneOperatore.setId(id);
                missioneOperatori.add(missioneOperatore);
            }
            missione.setMissioneOperatori(missioneOperatori);
        } else {
            missione.setMissioneOperatori(new HashSet<>());
        }

        // Salva la missione con gli operatori
        Missione missioneSalvata = missioneRepository.save(missione);
        return missioneMapper.toResponse(missioneSalvata);
    }

    @Transactional
    public MissioneResponse chiudiMissione(Long id) {

        Missione missione = missioneRepository.findById(id).orElseThrow();
        missione.setStato(Missione.StatoMissione.CHIUSA);
        richiestaService.modificaRichiesta(missione.getRichiesta().getId(), "CHIUSA");
        missione.setFineAt(LocalDateTime.now());

        Missione missioneSalvata = missioneRepository.save(missione);
        return missioneMapper.toResponse(missioneSalvata);
    }

    public MissioneResponse dettagliMissione(Long id) {
        Missione missione = missioneRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Missione non trovata con ID: " + id));
        return missioneMapper.toResponse(missione);
    }

    public List<MissioneResponse> missioniOperatore(Long id) {
        List<Missione> missioni = missioneRepository.findAllByOperatoreId(id);
        return missioneMapper.toResponseList(missioni);
    }

    // TODO: Implementare findAllByOperatoreId in Repository se manca, o usare query
    // su MissioneOperatore

    public List<MissioneResponse> tutteLeMissioni() {
        List<Missione> missioni = missioneRepository.findAll();
        return missioneMapper.toResponseList(missioni);
    }

    @Transactional
    public MissioneResponse aggiornaMissione(Long id, MissioneUpdateRequest updateRequest) {
        Missione missione = missioneRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Missione non trovata con ID: " + id));

        // Aggiorna solo i campi forniti (non null)
        if (updateRequest.getObiettivo() != null) {
            missione.setObiettivo(updateRequest.getObiettivo());
        }

        if (updateRequest.getCaposquadraId() != null) {
            Caposquadra caposquadra = caposquadraRepository.findByUtenteId(updateRequest.getCaposquadraId())
                    .orElseThrow(() -> new EntityNotFoundException(
                            "Caposquadra non trovato per utente ID: " + updateRequest.getCaposquadraId()));
            missione.setCaposquadra(caposquadra);
        }

        if (updateRequest.getPosizione() != null) {
            missione.setPosizione(updateRequest.getPosizione());
        }

        if (updateRequest.getLatitudine() != null) {
            missione.setLatitudine(updateRequest.getLatitudine());
        }

        if (updateRequest.getLongitudine() != null) {
            missione.setLongitudine(updateRequest.getLongitudine());
        }

        if (updateRequest.getStato() != null) {
            Missione.StatoMissione nuovoStato = Missione.StatoMissione.valueOf(updateRequest.getStato().toUpperCase());
            missione.setStato(nuovoStato);

            // Se la missione viene chiusa o fallita, imposta anche la data di fine
            if (nuovoStato == Missione.StatoMissione.CHIUSA || nuovoStato == Missione.StatoMissione.FALLITA) {
                missione.setFineAt(LocalDateTime.now());

                // Aggiorna anche lo stato della richiesta
                RichiestaSoccorso richiesta = missione.getRichiesta();
                if (richiesta != null) {
                    RichiestaSoccorso.StatoRichiesta statoRichiesta = nuovoStato == Missione.StatoMissione.CHIUSA
                            ? RichiestaSoccorso.StatoRichiesta.CHIUSA
                            : RichiestaSoccorso.StatoRichiesta.IGNORATA;
                    richiesta.setStato(statoRichiesta);
                }
            }
        }

        if (updateRequest.getCommentiFinali() != null) {
            missione.setCommentiFinali(updateRequest.getCommentiFinali());
        }

        // Gestisce operatori se forniti
        if (updateRequest.getOperatoriIds() != null) {
            // Poi assegna i nuovi operatori (sovrascrive o aggiunge? logica originale era
            // complessa, qui semplifico: sostituzione completa se inviati)

            Set<MissioneOperatore> missioneOperatori = new HashSet<>();
            if (!updateRequest.getOperatoriIds().isEmpty()) {
                List<User> operatori = userRepository.findAllById(updateRequest.getOperatoriIds());
                for (User operatore : operatori) {

                    MissioneOperatore missioneOperatore = new MissioneOperatore();
                    missioneOperatore.setOperatore(operatore);
                    missioneOperatore.setMissione(missione);
                    missioneOperatore.setAssegnatoAt(LocalDateTime.now());
                    MissioneOperatore.MissioneOperatoreId moid = new MissioneOperatore.MissioneOperatoreId();
                    moid.setMissioneId(missione.getId());
                    moid.setOperatoreId(operatore.getId());
                    missioneOperatore.setId(moid);
                    missioneOperatori.add(missioneOperatore);
                }
            }
            missione.getMissioneOperatori().clear();
            missione.getMissioneOperatori().addAll(missioneOperatori);
        }

        missione.setUpdatedAt(LocalDateTime.now());
        Missione missioneAggiornata = missioneRepository.save(missione);
        return missioneMapper.toResponse(missioneAggiornata);
    }
}
