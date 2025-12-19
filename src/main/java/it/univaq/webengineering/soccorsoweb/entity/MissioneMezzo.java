package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entity che rappresenta la relazione Many-to-Many tra Missione e Mezzo
 */
@Entity
@Table(name = "missioni_mezzi", indexes = {
        @Index(name = "idx_mezzo", columnList = "mezzo_id")
})
@Data
public class MissioneMezzo {

    @EmbeddedId
    private MissioneMezzoId id = new MissioneMezzoId();

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("missioneId")
    @JoinColumn(name = "missione_id")
    private Missione missione;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("mezzoId")
    @JoinColumn(name = "mezzo_id")
    private Mezzo mezzo;

    @Column(name = "assegnato_at")
    private LocalDateTime assegnatoAt;

    @PrePersist
    protected void onCreate() {
        if (assegnatoAt == null) {
            assegnatoAt = LocalDateTime.now();
        }
    }

    /**
     * Classe embedded per la chiave composta
     */
    @Embeddable
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class MissioneMezzoId implements Serializable {

        @Column(name = "missione_id")
        private Long missioneId;

        @Column(name = "mezzo_id")
        private Long mezzoId;
    }
}

