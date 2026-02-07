package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.mapper.UserMapper;
import it.univaq.webengineering.soccorsoweb.model.dto.request.NuovoOperatoreRequest;
import it.univaq.webengineering.soccorsoweb.model.entity.Role;
import it.univaq.webengineering.soccorsoweb.model.entity.User;
import it.univaq.webengineering.soccorsoweb.repository.RoleRepository;
import it.univaq.webengineering.soccorsoweb.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Random;

@Slf4j
@Service
@RequiredArgsConstructor
public class CredenzialiService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final EmailService emailService;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    Random random = new Random();
    String dominio = "soccorsoweb.it";

    public void generaCredenziali(String type) {
        User u = new User();
        u.setRoles(new HashSet<>());

        if (type.equalsIgnoreCase("admin")) {
            // ID 1 = ADMIN according to DB population
            Role adminRole = roleRepository.findById(1L)
                    .orElseThrow(() -> new RuntimeException("Ruolo admin non trovato"));
            u.getRoles().add(adminRole);
        } else {
            // ID 2 = OPERATORE according to DB population
            Role userRole = roleRepository.findById(2L)
                    .orElseThrow(() -> new RuntimeException("Ruolo user non trovato"));
            u.getRoles().add(userRole);
        }
        String username = type.toLowerCase() + random.nextInt(1000, 9999) + "@" + dominio;
        String password = "Passw0rd!" + random.nextInt(1000, 9999);

        u.setEmail(username);
        u.setNome(type);
        u.setCognome(type);
        u.setAttivo(true);
        u.setPassword(passwordEncoder.encode(password)); // Hash it!

        userRepository.save(u);
        emailService.inviaCredenziali(u.getEmail(), u.getEmail(), password);
    }

    public void registraNuovoOperatore(NuovoOperatoreRequest request) {
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email già in uso: " + request.getEmail());
        }

        User user = new User();
        user.setEmail(request.getEmail());
        user.setNome(request.getNome());
        user.setCognome(request.getCognome());
        user.setDataNascita(request.getDataNascita());
        user.setTelefono(request.getTelefono());
        user.setIndirizzo(request.getIndirizzo());
        user.setAttivo(true);
        user.setRoles(new HashSet<>());

        if (request.getRuoli() != null && !request.getRuoli().isEmpty()) {
            request.getRuoli().forEach(r -> {
                String name = r.getName();
                Role role = roleRepository.findByName(name)
                        .or(() -> roleRepository.findByName("ROLE_" + name))
                        .or(() -> {
                            // Fallback for legacy IDs if names don't match standard
                            if ("ADMIN".equalsIgnoreCase(name))
                                return roleRepository.findById(1L);
                            if ("OPERATORE".equalsIgnoreCase(name))
                                return roleRepository.findById(2L);
                            return java.util.Optional.empty();
                        })
                        .orElseThrow(() -> new RuntimeException("Ruolo non trovato: " + name));
                user.getRoles().add(role);
            });
        } else {
            // Assign Role OPERATORE (ID 2) default
            Role operatoreRole = roleRepository.findById(2L)
                    .orElseThrow(() -> new RuntimeException("Ruolo OPERATORE non trovato"));
            user.getRoles().add(operatoreRole);
        }

        // Password from request
        String rawPassword = request.getPassword();
        user.setPassword(passwordEncoder.encode(rawPassword));

        userRepository.save(user);

        // Send Email with Raw Password and Link
        emailService.inviaCredenziali(user.getEmail(), user.getEmail(), rawPassword);
    }

    /**
     * Imposta firstAttempt a false dopo il primo login
     * 
     * @param email email dell'utente
     */
    @Transactional
    public void setFirstAttemptFalse(String email) {
        log.info("📝 Aggiornamento firstAttempt per utente: {}", email);
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Utente non trovato: " + email));
        user.setFirstAttempt(false);
        userRepository.save(user);
        log.info("✅ firstAttempt aggiornato a false per utente: {}", email);
    }

    @Transactional
    public void changePassword(String email, String oldPassword, String newPassword) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Utente non trovato: " + email));

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("La vecchia password non è corretta");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        user.setFirstAttempt(false);
        userRepository.save(user);
        log.info("✅ Password modificata con successo per utente: {}", email);
    }
}
