package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class SquadraRequest {

    @NotBlank(message = "Il nome della squadra è obbligatorio")
    @Size(max = 100, message = "Il nome della squadra non può superare i 100 caratteri")
    private String nome;

    private String descrizione;

    @NotNull(message = "L'ID del caposquadra è obbligatorio")
    private Long caposquadraId;

    // IDs degli operatori da assegnare alla squadra
    private Set<Long> operatoriIds;
}
