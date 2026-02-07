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
public class MezzoRequest {

    @NotBlank(message = "Il nome del mezzo è obbligatorio")
    @Size(max = 100, message = "Il nome del mezzo non può superare i 100 caratteri")
    private String nome;

    private String descrizione;

    @Size(max = 50, message = "Il tipo non può superare i 50 caratteri")
    private String tipo;

    @Size(max = 20, message = "La targa non può superare i 20 caratteri")
    private String targa;

    private Boolean disponibile;
}
