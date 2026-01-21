package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.Data;


@Entity
@Table(name = "utenti_abilita")
@Data
public class UtentiAbilita {

    @EmbeddedId
    private UtentiAbilitaId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("utenteId")
    @JoinColumn(name = "utente_id")
    private Utenti utente;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("abilitaId")
    @JoinColumn(name = "abilita_id")
    private Abilita abilita;

    @Column(length = 50)
    private String livello;

}
