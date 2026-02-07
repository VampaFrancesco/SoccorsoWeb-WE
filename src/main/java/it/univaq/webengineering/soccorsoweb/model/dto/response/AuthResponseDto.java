package it.univaq.webengineering.soccorsoweb.model.dto.response;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class AuthResponseDto {

    private String token;
    @Builder.Default
    private String type = "Bearer";
    private UserResponse user;

    public AuthResponseDto(String token, UserResponse user) {
        this.token = token;
        this.user = user;
        this.type = "Bearer";
    }
}
