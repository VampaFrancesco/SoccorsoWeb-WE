package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Table(name = "squadra_operatori", indexes = {
        @Index(name = "idx_user_id", columnList = "user_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SquadraOperatore {

    @EmbeddedId
    private SquadraOperatoreId id;

    @ManyToOne
    @MapsId("squadraId")
    @JoinColumn(name = "squadra_id")
    private Squadra squadra;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User operatore;

    @Column(length = 50)
    private String ruolo;

    @Column(name = "assegnato_il")
    private LocalDate assegnatoIl;

    @Embeddable
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class SquadraOperatoreId implements Serializable {
        @Column(name = "squadra_id")
        private Long squadraId;

        @Column(name = "user_id")
        private Long userId;
    }
}
