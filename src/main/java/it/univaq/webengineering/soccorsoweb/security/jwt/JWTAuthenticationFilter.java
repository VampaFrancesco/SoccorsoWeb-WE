package it.univaq.webengineering.soccorsoweb.security.jwt;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;


@Component
public class JWTAuthenticationFilter extends OncePerRequestFilter {

    private final JWTUtil jwtUtil;
    private final UserDetailsService userDetailsService;

    // Constructor Injection - @Autowired opzionale con un solo costruttore
    public JWTAuthenticationFilter(JWTUtil jwtUtil,
                                   UserDetailsService userDetailsService) {
        this.jwtUtil = jwtUtil;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        // 1. Estrai l'header Authorization
        final String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        // 2. Estrai il token JWT (rimuovi "Bearer ")
        final String jwt = authHeader.substring(7);
        final String userEmail = jwtUtil.extractUsername(jwt);

        // 3. Se l'utente non è già autenticato
        if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {

            // 4. Carica i dettagli dell'utente
            UserDetails userDetails = userDetailsService.loadUserByUsername(userEmail);

            // 5. Valida il token
            if (jwtUtil.validateToken(jwt, userDetails)) {

                // 6. Crea l'oggetto Authentication
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

        // 8. Procedi con la filter chain
        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return  path.startsWith("/v3/api-docs") ||
                path.startsWith("/swagger-ui") ||
                path.startsWith("/swa/open") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/static/") ||
                path.equals("/") ||
                path.equals("/index.html") ||
                path.endsWith(".html") ||
                path.endsWith(".css") ||
                path.endsWith(".js");
    }
}