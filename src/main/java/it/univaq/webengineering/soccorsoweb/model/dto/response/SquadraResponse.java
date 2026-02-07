package it.univaq.webengineering.soccorsoweb.model.dto.response;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class SquadraResponse {
    private Long id;
    private String nome;
    private String descrizione;
    private UserResponse caposquadra;
    private Boolean attiva;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Set<SquadraOperatoreResponse> operatori;
}
