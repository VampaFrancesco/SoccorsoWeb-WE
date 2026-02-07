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

    public OperatoreService(UserMapper userMapper, UserRepository userRepository) {
        this.userMapper = userMapper;
        this.userRepository = userRepository;
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

        return userMapper.toResponse(userRepository.save(user));
    }
}
