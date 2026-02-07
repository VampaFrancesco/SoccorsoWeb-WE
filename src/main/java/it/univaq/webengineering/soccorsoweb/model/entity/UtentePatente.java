package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Table(name = "user_patenti", indexes = {
        @Index(name = "idx_patente_id", columnList = "patente_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UtentePatente {

    @EmbeddedId
    private UtentePatenteId id;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User utente;

    @ManyToOne
    @MapsId("patenteId")
    @JoinColumn(name = "patente_id")
    private Patente patente;

    @Column(name = "conseguita_il")
    private LocalDate conseguitaIl;

    @Embeddable
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class UtentePatenteId implements Serializable {
        @Column(name = "user_id")
        private Long userId;

        @Column(name = "patente_id")
        private Long patenteId;
    }
}
