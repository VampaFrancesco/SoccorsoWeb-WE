package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.NotBlank;
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
public class PatenteRequest {

    @NotBlank(message = "Il tipo della patente è obbligatorio")
    @Size(max = 50, message = "Il tipo della patente non può superare i 50 caratteri")
    private String tipo;

    private String descrizione;
}
