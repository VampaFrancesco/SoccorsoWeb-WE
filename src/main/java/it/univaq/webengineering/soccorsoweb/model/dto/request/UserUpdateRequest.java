package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class UserUpdateRequest {

    @Size(max = 100, message = "Il nome non può superare i 100 caratteri")
    private String nome;

    @Size(max = 100, message = "Il cognome non può superare i 100 caratteri")
    private String cognome;

    private LocalDate dataNascita;

    @Size(max = 20, message = "Il telefono non può superare i 20 caratteri")
    private String telefono;

    private String indirizzo;

    // Per semplificare, manteniamo la stringa separata da virgola per
    // retrocompatibilità in questa fase
    // ma la logica nel service verrà adattata per gestire meglio l'aggiornamento
    // In un refactoring completo, qui useremmo List<Long> o List<AbilitaDto>
    private String abilita;

    private Boolean disponibile;

    // Elenco strutturato di patenti
    private java.util.List<UserPatenteDto> patenti;
}
