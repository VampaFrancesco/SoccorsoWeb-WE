package it.univaq.webengineering.soccorsoweb.security.userdetails;

import it.univaq.webengineering.soccorsoweb.model.entity.User;
import it.univaq.webengineering.soccorsoweb.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.jspecify.annotations.NullMarked;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j // ✅ Per logging
@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    // Constructor Injection
    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional(readOnly = true)//IMPORTANTE: garantisce accesso a user.getRoles()
    @NullMarked
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        log.info("Loading user by email: {}", email);

        // 1. Carica la TUA entity User dal database
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));

        // ✅ Verifica se l'utente è attivo
        if (!user.getAttivo()) {
            log.warn("Tentativo di login con account disattivato: {}", email);
            throw new UsernameNotFoundException("Account disattivato: " + email);
        }

        // 2. Converti i ruoli dell'entity in GrantedAuthority di Spring Security
        List<GrantedAuthority> authorities = user.getRoles().stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getName()))
                .collect(Collectors.toList());

        log.info("User {} caricato con ruoli: {}", email, authorities);

        // 3. Ritorna lo User di SPRING SECURITY (non l'entity!)
        return org.springframework.security.core.userdetails.User
                .builder()
                .username(user.getEmail())
                .password(user.getPassword()) // ✅ Già hashata nel DB
                .authorities(authorities) // ✅ ROLE_ADMIN, ROLE_OPERATORE
                .disabled(!user.getAttivo()) // ✅ Se attivo=false → disabled=true
                .accountExpired(false)
                .accountLocked(false)
                .credentialsExpired(false)
                .build();
    }
}
