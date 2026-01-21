package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Entity
@Table(name = "squadre_operatori")
@Data
public class SquadreOperatori {

    @EmbeddedId
    private SquadreOperatoriId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("squadraId")
    @JoinColumn(name = "squadra_id")
    private Squadra squadra;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("utenteId")
    @JoinColumn(name = "utente_id")
    private Utenti utente;

    @Column(length = 50)
    private String ruolo;

    @Column(name = "assegnato_il")
    private LocalDate assegnatoIl;

}
