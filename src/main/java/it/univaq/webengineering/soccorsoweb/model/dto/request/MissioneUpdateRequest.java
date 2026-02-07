package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Set;

/**
 * DTO per la modifica parziale di una missione
 * Tutti i campi sono opzionali per permettere modifiche parziali
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class MissioneUpdateRequest {

    private String obiettivo;

    private Long caposquadraId;

    private String posizione;

    private BigDecimal latitudine;

    private BigDecimal longitudine;

    private String stato; // IN_CORSO, CHIUSA, FALLITA


    private String commentiFinali;

    // IDs operatori da assegnare (sostituisce gli operatori esistenti se presente)
    private Set<Long> operatoriIds;
}

