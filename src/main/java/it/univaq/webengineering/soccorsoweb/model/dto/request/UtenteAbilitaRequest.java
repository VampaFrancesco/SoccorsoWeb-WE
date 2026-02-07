package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class UtenteAbilitaRequest {

    @NotNull(message = "L'ID dell'utente è obbligatorio")
    private Long userId;

    @NotNull(message = "L'ID dell'abilità è obbligatorio")
    private Long abilitaId;

    @Size(max = 50, message = "Il livello non può superare i 50 caratteri")
    private String livello;
}
