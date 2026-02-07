package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "missione_materiali", indexes = {
        @Index(name = "idx_materiale", columnList = "materiale_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MissioneMateriale {

    @EmbeddedId
    private MissioneMaterialeId id;

    @ManyToOne
    @MapsId("missioneId")
    @JoinColumn(name = "missione_id")
    private Missione missione;

    @ManyToOne
    @MapsId("materialeId")
    @JoinColumn(name = "materiale_id")
    private Materiale materiale;

    @Builder.Default
    @Column(name = "quantita_usata", nullable = false)
    private Integer quantitaUsata = 1;

    @CreationTimestamp
    @Column(name = "assegnato_at", updatable = false)
    private LocalDateTime assegnatoAt;

    @Embeddable
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class MissioneMaterialeId implements Serializable {
        @Column(name = "missione_id")
        private Long missioneId;

        @Column(name = "materiale_id")
        private Long materialeId;
    }
}
