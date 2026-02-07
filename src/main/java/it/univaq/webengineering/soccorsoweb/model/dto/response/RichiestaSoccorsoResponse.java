package it.univaq.webengineering.soccorsoweb.model.dto.response;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class RichiestaSoccorsoResponse {

    private Long id;
    private String descrizione;
    private String indirizzo;
    private BigDecimal latitudine;
    private BigDecimal longitudine;
    private String nomeSegnalante;
    private String emailSegnalante;
    private String telefonoSegnalante;

    // Foto come byte array (Base64 encoded in JSON)
    private byte[] foto;

    private String ipOrigine;
    private String tokenConvalida;
    private String stato;
    private LocalDateTime convalidataAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ID della missione associata (se esiste)
    private Long missioneId;
}
