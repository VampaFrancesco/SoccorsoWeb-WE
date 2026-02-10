package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

/**
 * DTO per la modifica parziale di una missione
 * Tutti i campi sono opzionali per permettere modifiche parziali
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MissioneUpdateRequest {

    private String obiettivo;

    @JsonProperty("caposquadra_id")
    private Long caposquadraId;

    private String posizione;

    private BigDecimal latitudine;

    private BigDecimal longitudine;

    private String stato; // IN_CORSO, CHIUSA, FALLITA

    @JsonProperty("commenti_finali")
    private String commentiFinali;

    @JsonProperty("livello_successo")
    @Min(0)
    @Max(5)
    private Integer livelloSuccesso;

    @JsonProperty("operatori_ids")
    private Set<Long> operatoriIds;

    private List<AggiornamentoEntry> aggiornamenti;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AggiornamentoEntry {
        private String descrizione;
    }
}
