package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;

@Entity
@Table(name="utenti_ruoli")
@Data
public class UtentiRuoli {

    @EmbeddedId
    private UtentiRuoliPk id = new UtentiRuoliPk();

    @ManyToOne(fetch=FetchType.LAZY)
    @MapsId("utenteId")
    @JoinColumn(name = "utente_id", referencedColumnName = "id")
    private Utenti utenti;
    @ManyToOne(fetch=FetchType.LAZY)
    @MapsId("ruoloId")
    @JoinColumn(name = "ruolo_id", referencedColumnName = "id")
    private Ruoli ruoli;

    @Embeddable
    @Data
    public static class UtentiRuoliPk implements Serializable {

        @Column
        private Long utenteId;

        @Column
        private Long ruoloId;

    }


}