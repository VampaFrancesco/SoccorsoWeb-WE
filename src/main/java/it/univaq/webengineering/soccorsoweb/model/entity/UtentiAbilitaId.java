package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.Data;

import java.io.Serializable;

@Embeddable
@Data
public class UtentiAbilitaId implements Serializable {

    @Column(name = "utente_id")
    private Long utenteId;

    @Column(name = "abilita_id")
    private Long abilitaId;

}
