package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO per la richiesta di conferma convalida
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConvalidaRequest {

    @NotBlank(message = "Il token di convalida è obbligatorio")
    @JsonProperty("token_convalida")
    private String tokenConvalida;
}

