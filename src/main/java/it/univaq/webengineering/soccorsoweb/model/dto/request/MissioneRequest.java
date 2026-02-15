package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
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
    @JsonProperty("richiesta_id")
    private Long richiestaId;

    @NotBlank(message = "L'obiettivo è obbligatorio")
    private String obiettivo;

    @NotNull(message = "Almeno un caposquadra è obbligatorio")
    @JsonProperty("caposquadra_ids")
    private Set<Long> caposquadraIds;

    // ID della squadra (opzionale)
    private Long squadraId;

    private String posizione;
    private BigDecimal latitudine;
    private BigDecimal longitudine;

    // IDs operatori da assegnare
    @JsonProperty("operatori_ids")
    private Set<Long> operatoriIds;

    // IDs mezzi da assegnare
    @JsonProperty("mezzi_ids")
    private Set<Long> mezziIds;

    // IDs materiali da assegnare (con quantità)
    private Set<MissioneMaterialeAssignment> materiali;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
    public static class MissioneMaterialeAssignment {
        @JsonProperty("materiale_id")
        private Long materialeId;
        @JsonProperty("quantita_usata")
        private Integer quantitaUsata;
    }
}
