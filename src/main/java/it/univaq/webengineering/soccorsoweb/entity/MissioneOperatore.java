package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entity che rappresenta la relazione Many-to-Many tra Missione e Operatore (Utente)
 */
@Entity
@Table(name = "missioni_operatori", indexes = {
        @Index(name = "idx_operatore", columnList = "operatore_id")
})
@Data
public class MissioneOperatore {

    @EmbeddedId
    private MissioneOperatoreId id = new MissioneOperatoreId();

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("missioneId")
    @JoinColumn(name = "missione_id")
    private Missione missione;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("operatoreId")
    @JoinColumn(name = "operatore_id")
    private Utenti operatore;

    @Column(name = "notificato_at")
    private LocalDateTime notificatoAt;

    @Column(name = "assegnato_at")
    private LocalDateTime assegnatoAt;

    /**
     * Classe embedded per la chiave composta
     */
    @Embeddable
    @Data
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

