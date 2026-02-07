package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class MissioneRequest {

    @NotNull(message = "L'ID della richiesta è obbligatorio")
    private Long richiestaId;

    @NotBlank(message = "L'obiettivo è obbligatorio")
    private String obiettivo;

    @NotNull(message = "Il caposquadra è obbligatorio")
    private Long caposquadraId;

    // ID della squadra (opzionale)
    private Long squadraId;

    private String posizione;
    private BigDecimal latitudine;
    private BigDecimal longitudine;

    // IDs operatori da assegnare
    private Set<Long> operatoriIds;

    // IDs mezzi da assegnare
    private Set<Long> mezziIds;

    // IDs materiali da assegnare (con quantità)
    private Set<MissioneMaterialeAssignment> materiali;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MissioneMaterialeAssignment {
        private Long materialeId;
        private Integer quantitaUsata;
    }
}
