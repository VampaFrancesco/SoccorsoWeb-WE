package it.univaq.webengineering.soccorsoweb.model.dto.response;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class UserResponse {
    private Long id;
    private String email;
    private String nome;
    private String cognome;
    private LocalDate dataNascita;
    private String telefono;
    private String indirizzo;
    private Boolean attivo;
    private Boolean firstAttempt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Set<RoleResponse> roles;
    private Set<PatenteResponse> patenti;
    private Set<AbilitaResponse> abilita;
    private String token; // JWT token per autenticazione
}
