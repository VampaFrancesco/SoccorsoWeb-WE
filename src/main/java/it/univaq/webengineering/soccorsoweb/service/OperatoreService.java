package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.UserMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.UserRequest;
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

    public OperatoreService(UserMapper userMapper, UserRepository userRepository,
            it.univaq.webengineering.soccorsoweb.repository.AbilitaRepository abilitaRepository) {
        this.userMapper = userMapper;
        this.userRepository = userRepository;
        this.abilitaRepository = abilitaRepository;
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
                    boolean hasAdmin = ruoli.stream().anyMatch(role -> role.getName().equals("ADMIN"));
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
        String email = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication()
                .getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new EntityNotFoundException("Utente corrente non trovato"));
        return userMapper.toResponse(user);
    }

    public UserResponse updateProfile(UserUpdateRequest request) {
        String email = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication()
                .getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new EntityNotFoundException("Utente corrente non trovato"));

        userMapper.updateEntityFromDto(request, user);

        // Gestione Abilità (Stringa separata da virgola)
        if (request.getAbilita() != null) {
            // 1. Pulisci le abilità esistenti (per semplificare, rimpiazziamo tutto)
            user.getAbilita().clear();

            String[] skills = request.getAbilita().split(",");
            for (String skillName : skills) {
                skillName = skillName.trim();
                if (!skillName.isEmpty()) {
                    // 2. Trova o crea l'Abilita
                    String finalSkillName = skillName; // per lambda
                    it.univaq.webengineering.soccorsoweb.model.entity.Abilita abilita = abilitaRepository
                            .findByNome(skillName)
                            .orElseGet(() -> abilitaRepository.save(
                                    it.univaq.webengineering.soccorsoweb.model.entity.Abilita.builder()
                                            .nome(finalSkillName)
                                            .build()));

                    // 3. Crea la relazione UtenteAbilita
                    it.univaq.webengineering.soccorsoweb.model.entity.UtenteAbilita relazione = new it.univaq.webengineering.soccorsoweb.model.entity.UtenteAbilita();
                    relazione.setUtente(user);
                    relazione.setAbilita(abilita);
                    relazione.setLivello("Base"); // Default

                    // Imposta l'ID composto
                    it.univaq.webengineering.soccorsoweb.model.entity.UtenteAbilita.UtenteAbilitaId id = new it.univaq.webengineering.soccorsoweb.model.entity.UtenteAbilita.UtenteAbilitaId(
                            user.getId(), abilita.getId());
                    relazione.setId(id);

                    // Aggiungi alla collezione dell'utente
                    user.getAbilita().add(relazione);
                }
            }
        }

        return userMapper.toResponse(userRepository.save(user));
    }
}
