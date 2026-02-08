package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RichiestaSoccorsoRequest {

    @NotBlank(message = "La descrizione è obbligatoria")
    private String descrizione;

    @NotBlank(message = "L'indirizzo è obbligatorio")
    private String indirizzo;

    @DecimalMin(value = "-90.0", message = "La latitudine deve essere >= -90")
    @DecimalMax(value = "90.0", message = "La latitudine deve essere <= 90")
    private BigDecimal latitudine;

    @DecimalMin(value = "-180.0", message = "La longitudine deve essere >= -180")
    @DecimalMax(value = "180.0", message = "La longitudine deve essere <= 180")
    private BigDecimal longitudine;

    @NotBlank(message = "Il nome del segnalante è obbligatorio")
    @JsonProperty("nome_segnalante")
    private String nomeSegnalante;

    @NotBlank(message = "L'email del segnalante è obbligatoria")
    @Email(message = "L'email del segnalante deve essere valida")
    @JsonProperty("email_segnalante")
    private String emailSegnalante;

    @Size(max = 20, message = "Il telefono non può superare i 20 caratteri")
    @JsonProperty("telefono_segnalante")
    private String telefonoSegnalante;

    private String ipOrigine;

    // Foto come byte array (Base64 encoded in JSON)
    private byte[] foto;
}
