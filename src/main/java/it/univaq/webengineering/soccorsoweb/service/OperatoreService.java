package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.UserMapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.UserUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.UserResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Role;
import it.univaq.webengineering.soccorsoweb.model.entity.User;
import it.univaq.webengineering.soccorsoweb.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class OperatoreService {

        private final UserMapper userMapper;
        private final UserRepository userRepository;
        private final it.univaq.webengineering.soccorsoweb.repository.AbilitaRepository abilitaRepository;
        private final it.univaq.webengineering.soccorsoweb.repository.PatenteRepository patenteRepository;

        public OperatoreService(UserMapper userMapper, UserRepository userRepository,
                        it.univaq.webengineering.soccorsoweb.repository.AbilitaRepository abilitaRepository,
                        it.univaq.webengineering.soccorsoweb.repository.PatenteRepository patenteRepository) {
                this.userMapper = userMapper;
                this.userRepository = userRepository;
                this.abilitaRepository = abilitaRepository;
                this.patenteRepository = patenteRepository;
        }

        /**
         * Restituisce la lista degli operatori disponibili o non disponibili.
         * Un operatore è considerato "disponibile" se:
         * 1. Ha il campo disponibile = true
         * 2. Non è attualmente assegnato a nessuna missione con stato IN_CORSO
         *
         * Gli operatori con ruolo ADMIN sono esclusi dalla lista.
         */
        public List<UserResponse> operatoreDisponibile(boolean disponibili) {
                List<User> operatori = userRepository.findOperatoriByDisponibile(disponibili);

                // Filtra per escludere gli ADMIN (mantiene solo OPERATORE puro)
                List<User> operatoriFiltrati = operatori.stream()
                                .filter(operatore -> {
                                        List<Role> ruoli = operatore.getRoles().stream().toList();
                                        boolean hasAdmin = ruoli.stream()
                                                        .anyMatch(role -> role.getName().equals("ADMIN"));
                                        // Esclude chi ha anche ruolo ADMIN
                                        return !hasAdmin;
                                })
                                .toList();

                return userMapper.toResponseList(operatoriFiltrati);
        }

        public UserResponse dettagliOperatore(Long id) {

                User operatore = userRepository.findById(id)
                                .orElseThrow(() -> new EntityNotFoundException("Operatore non trovato con ID: " + id));
                boolean isOperatore = operatore.getRoles().stream()
                                .anyMatch(role -> role.getName().equals("OPERATORE"));
                if (!isOperatore) {
                        throw new IllegalArgumentException("L'utente con ID " + id + " non è un operatore");
                }
                return userMapper.toResponse(operatore);
        }

        public void deleteUser(Long id) {
                if (!userRepository.existsById(id)) {
                        throw new EntityNotFoundException("Utente non trovato con ID: " + id);
                }
                userRepository.deleteById(id);
        }

        public UserResponse getProfile() {
                String email = org.springframework.security.core.context.SecurityContextHolder.getContext()
                                .getAuthentication()
                                .getName();
                User user = userRepository.findByEmail(email)
                                .orElseThrow(() -> new EntityNotFoundException("Utente corrente non trovato"));
                return userMapper.toResponse(user);
        }

        public UserResponse updateProfile(UserUpdateRequest request) {
                String email = org.springframework.security.core.context.SecurityContextHolder.getContext()
                                .getAuthentication()
                                .getName();
                User user = userRepository.findByEmail(email)
                                .orElseThrow(() -> new EntityNotFoundException("Utente corrente non trovato"));

                userMapper.updateEntityFromDto(request, user);

                // Gestione Abilità
                if (request.getAbilita() != null) {
                        String[] skills = request.getAbilita().split(",");
                        java.util.Set<String> newSkills = java.util.Arrays.stream(skills)
                                        .map(String::trim)
                                        .filter(s -> !s.isEmpty())
                                        .collect(java.util.stream.Collectors.toSet());

                        // Rimuovi abilità non più presenti
                        user.getAbilita().removeIf(ua -> !newSkills.contains(ua.getAbilita().getNome()));

                        // Aggiungi nuove abilità
                        for (String skillName : newSkills) {
                                boolean alreadyHas = user.getAbilita().stream()
                                                .anyMatch(ua -> ua.getAbilita().getNome().equals(skillName));

                                if (!alreadyHas) {
                                        it.univaq.webengineering.soccorsoweb.model.entity.Abilita abilita = abilitaRepository
                                                        .findByNome(skillName)
                                                        .orElseGet(() -> abilitaRepository.save(
                                                                        it.univaq.webengineering.soccorsoweb.model.entity.Abilita
                                                                                        .builder()
                                                                                        .nome(skillName)
                                                                                        .build()));

                                        it.univaq.webengineering.soccorsoweb.model.entity.UtenteAbilita relazione = new it.univaq.webengineering.soccorsoweb.model.entity.UtenteAbilita();
                                        relazione.setUtente(user);
                                        relazione.setAbilita(abilita);
                                        relazione.setLivello("Base");
                                        relazione.setId(new it.univaq.webengineering.soccorsoweb.model.entity.UtenteAbilita.UtenteAbilitaId(
                                                        user.getId(), abilita.getId()));
                                        user.getAbilita().add(relazione);
                                }
                        }
                }

                // Gestione Patenti
                if (request.getPatenti() != null) {
                        java.util.Set<String> newPatentiTypes = request.getPatenti().stream()
                                        .map(p -> p.getTipo().trim())
                                        .filter(s -> !s.isEmpty())
                                        .collect(java.util.stream.Collectors.toSet());

                        // Rimuovi patenti non più presenti
                        user.getPatenti().removeIf(up -> !newPatentiTypes.contains(up.getPatente().getTipo()));

                        // Aggiungi o aggiorna patenti
                        for (it.univaq.webengineering.soccorsoweb.model.dto.request.UserPatenteDto dto : request
                                        .getPatenti()) {
                                String patenteType = dto.getTipo().trim();

                                // Cerca se l'utente ha già questa patente
                                it.univaq.webengineering.soccorsoweb.model.entity.UtentePatente existingRelazione = user
                                                .getPatenti().stream()
                                                .filter(up -> up.getPatente().getTipo().equals(patenteType))
                                                .findFirst()
                                                .orElse(null);

                                if (existingRelazione != null) {
                                        // Aggiorna esistente
                                        if (dto.getConseguitaIl() != null) {
                                                existingRelazione.setConseguitaIl(dto.getConseguitaIl()); // LocalDate
                                        }
                                        if (dto.getRilasciataDa() != null) {
                                                existingRelazione.setRilasciataDa(dto.getRilasciataDa());
                                        }
                                } else {
                                        // Nuova patente
                                        it.univaq.webengineering.soccorsoweb.model.entity.Patente patente = patenteRepository
                                                        .findByTipo(patenteType)
                                                        .orElseGet(() -> patenteRepository.save(
                                                                        it.univaq.webengineering.soccorsoweb.model.entity.Patente
                                                                                        .builder()
                                                                                        .tipo(patenteType)
                                                                                        .build()));

                                        it.univaq.webengineering.soccorsoweb.model.entity.UtentePatente relazione = new it.univaq.webengineering.soccorsoweb.model.entity.UtentePatente();
                                        relazione.setUtente(user);
                                        relazione.setPatente(patente);
                                        // Usa data fornita o oggi come default
                                        relazione.setConseguitaIl(dto.getConseguitaIl() != null ? dto.getConseguitaIl()
                                                        : java.time.LocalDate.now());
                                        relazione.setRilasciataDa(dto.getRilasciataDa());

                                        relazione.setId(new it.univaq.webengineering.soccorsoweb.model.entity.UtentePatente.UtentePatenteId(
                                                        user.getId(), patente.getId()));
                                        user.getPatenti().add(relazione);
                                }
                        }
                }

                return userMapper.toResponse(userRepository.save(user));
        }
}
