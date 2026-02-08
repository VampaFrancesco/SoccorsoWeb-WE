package it.univaq.webengineering.soccorsoweb.model.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ChangePasswordRequest {

    @NotBlank(message = "La vecchia password è obbligatoria")
    @JsonProperty("old_password")
    private String oldPassword;

    @NotBlank(message = "La nuova password è obbligatoria")
    @JsonProperty("new_password")
    private String newPassword;
}
