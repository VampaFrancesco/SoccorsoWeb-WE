package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entity che rappresenta la relazione Many-to-Many tra Missione e Materiale
 */
@Entity
@Table(name = "missioni_materiali", indexes = {
        @Index(name = "idx_materiale", columnList = "materiale_id")
})
@Data
public class MissioneMateriale {

    @EmbeddedId
    private MissioneMaterialeId id = new MissioneMaterialeId();

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("missioneId")
    @JoinColumn(name = "missione_id")
    private Missione missione;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("materialeId")
    @JoinColumn(name = "materiale_id")
    private Materiale materiale;

    @Column(name = "quantita_usata", nullable = false)
    private Integer quantitaUsata = 1;

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
    public static class MissioneMaterialeId implements Serializable {

        @Column(name = "missione_id")
        private Long missioneId;

        @Column(name = "materiale_id")
        private Long materialeId;
    }
}

