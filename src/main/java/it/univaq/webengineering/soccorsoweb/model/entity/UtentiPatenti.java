package it.univaq.webengineering.soccorsoweb.model.entity;


import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.sql.Date;

@Entity
@Table(name="utenti_patenti")
@Data
public class UtentiPatenti {

    @EmbeddedId
    private UtentiPatentiPk utentiPatentiPk = new UtentiPatentiPk();

    @ManyToOne(fetch= FetchType.LAZY)
    @MapsId("utenteId")
    @JoinColumn(name = "utente_id", referencedColumnName = "id")
    private Utenti utenti;
    @ManyToOne(fetch=FetchType.LAZY)
    @MapsId("patenteId")
    @JoinColumn(name = "patente_id", referencedColumnName = "id")
    private Patenti patenti;

    @Column
    private Date conseguita_il;

    @Embeddable
    @Data
    public static class UtentiPatentiPk implements Serializable {

        @Column
        private Long utenteId;

        @Column
        private Long patenteId;

    }

}
