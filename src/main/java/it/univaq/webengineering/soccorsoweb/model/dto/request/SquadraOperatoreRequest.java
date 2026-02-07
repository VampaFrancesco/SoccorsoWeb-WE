package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class SquadraOperatoreRequest {

    @NotNull(message = "L'ID della squadra è obbligatorio")
    private Long squadraId;

    @NotNull(message = "L'ID dell'utente è obbligatorio")
    private Long userId;

    @Size(max = 50, message = "Il ruolo non può superare i 50 caratteri")
    private String ruolo;

    private LocalDate assegnatoIl;
}
