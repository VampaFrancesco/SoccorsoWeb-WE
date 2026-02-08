/**
 * 1. CLIENT invia POST /auth/login con JSON
 *    {
 *      "email": "user@example.com",
 *      "password": "password123"
 *    }
 *    ↓
 * 2. 🛡️ LoginValidationInterceptor (PRIMO controllo)
 *    - Verifica che ci siano i campi "email" e "password" nel JSON
 *    - Se MANCA qualcosa → 400 BAD REQUEST ❌ (ferma qui!)
 *    - Se OK → passa al prossimo step ✅
 */


package it.univaq.webengineering.soccorsoweb.security.interceptor;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;

@Component
public class LoginValidationInterceptor implements HandlerInterceptor {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        // Solo per POST /auth/login
        if (!request.getMethod().equals("POST") || !request.getRequestURI().contains("/auth/open/login")) {
            return true;
        }

        // Leggi il body della richiesta
        String body = request.getReader().lines()
                .reduce("", (accumulator, actual) -> accumulator + actual);

        // Controlla se mancano campi
        if (!body.contains("\"email\"") || !body.contains("\"password\"")) {
            sendErrorResponse(response, "Email e password sono obbligatori");
            return false;  // Blocca la richiesta
        }

        return true;  // Procedi normalmente
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        ProblemDetail problemDetail = ProblemDetail.forStatusAndDetail(
                HttpStatus.BAD_REQUEST,
                message
        );
        problemDetail.setTitle("Validation Error");

        response.setStatus(HttpStatus.BAD_REQUEST.value());
        response.setContentType("application/problem+json");
        response.getWriter().write(objectMapper.writeValueAsString(problemDetail));
    }
}