package it.univaq.webengineering.soccorsoweb.security.userdetails;

import it.univaq.webengineering.soccorsoweb.model.entity.Utenti;
import it.univaq.webengineering.soccorsoweb.repository.UtentiRepository;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.stream.Collectors;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UtentiRepository utentiRepository;

    public CustomUserDetailsService(UtentiRepository utentiRepository) {
        this.utentiRepository = utentiRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String email)
            throws UsernameNotFoundException {

        Utenti utente = utentiRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException(
                        "Utente non trovato: " + email));

        return User.builder()
                .username(utente.getEmail())
                .password(utente.getPassword())
                .authorities(getAuthorities(utente))
                .build();
    }

    private Collection<GrantedAuthority> getAuthorities(Utenti utente) {
        // Converti i ruoli dell'utente in GrantedAuthority
        return utente.getUtentiRuoli().stream()
                .map(ruolo -> new SimpleGrantedAuthority("ROLE_" + ruolo.getRuoli().getNome()))
                .collect(Collectors.toList());
    }
}

