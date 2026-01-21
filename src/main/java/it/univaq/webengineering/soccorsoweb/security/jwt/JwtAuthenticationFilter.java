package it.univaq.webengineering.soccorsoweb.security.jwt;

import it.univaq.webengineering.soccorsoweb.security.userdetails.CustomUserDetailsService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final CustomUserDetailsService userDetailsService;

    public JwtAuthenticationFilter(JwtService jwtService,
                                   CustomUserDetailsService userDetailsService) {
        this.jwtService = jwtService;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        try {
            // 1. Estrai il token dall'header Authorization
            String authHeader = request.getHeader("Authorization");
            String token = null;
            String username = null;

            // 2. Verifica se il token è presente e inizia con "Bearer "
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                token = authHeader.substring(7);  // Rimuovi "Bearer "
                username = jwtService.extractUsername(token);
            }

            // 3. Se il token è valido e non c'è già un'autenticazione
            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {

                // 4. Carica i dettagli dell'utente
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                // 5. Valida il token
                if (jwtService.validateToken(token, userDetails)) {

                    // 6. Crea l'oggetto di autenticazione
                    UsernamePasswordAuthenticationToken authToken =
                            new UsernamePasswordAuthenticationToken(
                                    userDetails,
                                    null,
                                    userDetails.getAuthorities()
                            );

                    authToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request)
                    );

                    // 7. Imposta l'autenticazione nel SecurityContext
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                }
            }
        } catch (Exception e) {
            // Log dell'errore (opzionale)
            logger.error("Cannot set user authentication: {}", e);
        }

        // 8. Passa alla prossima catena di filtri
        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        // Salta il filtro per gli endpoint pubblici
        String path = request.getRequestURI();
        return path.startsWith("/swa/open/") ||
                path.startsWith("/swagger-ui/") ||
                path.startsWith("/api-docs");
    }
}

