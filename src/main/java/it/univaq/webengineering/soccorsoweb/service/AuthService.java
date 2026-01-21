package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.model.dto.AuthRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.AuthResponse;
import it.univaq.webengineering.soccorsoweb.repository.UtentiRepository;
import it.univaq.webengineering.soccorsoweb.security.jwt.JwtService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UtentiRepository utentiRepository;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    // ✅ Dependency injection tramite costruttore
    public AuthService(UtentiRepository utentiRepository,
                       JwtService jwtService,
                       AuthenticationManager authenticationManager) {
        this.utentiRepository = utentiRepository;
        this.jwtService = jwtService;
        this.authenticationManager = authenticationManager;
    }

    // ✅ Metodo per verificare se email è già usata (per registrazione)
    public boolean isEmailTaken(String email) {
        return utentiRepository.findByEmail(email).isPresent();
    }

    // ✅ Metodo login che ritorna l'AuthResponse
    public ResponseEntity<AuthResponse> login(AuthRequest authRequest) {
        try {
            // 1. Autentica l'utente usando AuthenticationManager
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            authRequest.getEmail(),
                            authRequest.getPassword()
                    )
            );

            // 2. Se arrivo qui, l'autenticazione è riuscita
            // Genera il token JWT
            String token = jwtService.generateToken(authRequest.getEmail());

            // 3. Ritorna il token nella response
            return new AuthResponse(token);

        } catch (BadCredentialsException e) {
            // 4. Se le credenziali sono sbagliate, lancia eccezione
            throw new BadCredentialsException("Email o password non validi");
        }
    }
}
