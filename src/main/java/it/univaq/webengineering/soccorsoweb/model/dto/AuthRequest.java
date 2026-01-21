package it.univaq.webengineering.soccorsoweb.model.dto;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class AuthRequest {

    private String email;
    private String password;


}
