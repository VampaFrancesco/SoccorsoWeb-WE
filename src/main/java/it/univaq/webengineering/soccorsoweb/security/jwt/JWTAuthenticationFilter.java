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
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String jwt = null;

        // 1. Estrai l'header Authorization
        final String authHeader = request.getHeader("Authorization");

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwt = authHeader.substring(7);
        }

        // 2. Se non c'è header, prova i cookie
        if (jwt == null && request.getCookies() != null) {
            for (jakarta.servlet.http.Cookie cookie : request.getCookies()) {
                if ("jwt".equals(cookie.getName())) {
                    jwt = cookie.getValue();
                    break;
                }
            }
        }

        // Se ancora null, procedi con la filter chain
        if (jwt == null) {
            filterChain.doFilter(request, response);
            return;
        }

        // 3. Estrai userEmail dal token
        // Nota: extractUsername potrebbe lanciare eccezioni se il token è
        // malformato/scaduto
        // Idealmente dovresti gestirle, ma qui manteniamo la logica originale
        final String userEmail = jwtUtil.extractUsername(jwt);

        // 4. Se l'utente non è già autenticato
        if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {

            // 5. Carica i dettagli dell'utente
            UserDetails userDetails = userDetailsService.loadUserByUsername(userEmail);

            // 6. Valida il token
            if (jwtUtil.validateToken(jwt, userDetails)) {

                // 7. Crea l'oggetto Authentication
                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        userDetails,
                        null,
                        userDetails.getAuthorities());

                authToken.setDetails(
                        new WebAuthenticationDetailsSource().buildDetails(request));

                // 8. Imposta l'autenticazione nel SecurityContext
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }

        // 9. Procedi con la filter chain
        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return path.startsWith("/v3/api-docs") ||
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