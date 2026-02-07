package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "missione_mezzi", indexes = {
        @Index(name = "idx_mezzo", columnList = "mezzo_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MissioneMezzo {

    @EmbeddedId
    private MissioneMezzoId id;

    @ManyToOne
    @MapsId("missioneId")
    @JoinColumn(name = "missione_id")
    private Missione missione;

    @ManyToOne
    @MapsId("mezzoId")
    @JoinColumn(name = "mezzo_id")
    private Mezzo mezzo;

    @CreationTimestamp
    @Column(name = "assegnato_at", updatable = false)
    private LocalDateTime assegnatoAt;

    @Embeddable
    @Getter
    @Setter
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
