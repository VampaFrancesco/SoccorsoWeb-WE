package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.Data;

import java.io.Serializable;

@Embeddable
@Data
public class SquadreOperatoriId implements Serializable {

    @Column(name = "squadra_id")
    private Long squadraId;

    @Column(name = "utente_id")
    private Long utenteId;

}
