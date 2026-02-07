package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "missione_operatori", indexes = {
        @Index(name = "idx_operatore", columnList = "operatore_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MissioneOperatore {

    @EmbeddedId
    private MissioneOperatoreId id;

    @ManyToOne
    @MapsId("missioneId")
    @JoinColumn(name = "missione_id")
    private Missione missione;

    @ManyToOne
    @MapsId("operatoreId")
    @JoinColumn(name = "operatore_id")
    private User operatore;

    @Column(name = "notificato_at")
    private LocalDateTime notificatoAt;

    @Column(name = "assegnato_at")
    private LocalDateTime assegnatoAt;

    // Classe per la chiave composta
    @Embeddable
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class MissioneOperatoreId implements Serializable {
        @Column(name = "missione_id")
        private Long missioneId;

        @Column(name = "operatore_id")
        private Long operatoreId;
    }
}
