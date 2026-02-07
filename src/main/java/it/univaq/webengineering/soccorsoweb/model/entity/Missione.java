package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "missione", indexes = {
        @Index(name = "idx_stato", columnList = "stato"),
        @Index(name = "idx_caposquadra", columnList = "caposquadra_id"),
        @Index(name = "idx_squadra", columnList = "squadra_id"),
        @Index(name = "idx_richiesta", columnList = "richiesta_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Missione {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "richiesta_id", nullable = false, unique = true)
    private RichiestaSoccorso richiesta;

    @ManyToOne
    @JoinColumn(name = "squadra_id")
    private Squadra squadra;

    @ManyToOne
    @JoinColumn(name = "caposquadra_id", nullable = false)
    private Caposquadra caposquadra;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String obiettivo;

    private String posizione;

    @Column(precision = 10, scale = 8)
    private BigDecimal latitudine;

    @Column(precision = 11, scale = 8)
    private BigDecimal longitudine;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatoMissione stato = StatoMissione.IN_CORSO;

    @Builder.Default
    @Column(name = "inizio_at")
    private LocalDateTime inizioAt = LocalDateTime.now();

    @Column(name = "fine_at")
    private LocalDateTime fineAt;

    @Column(name = "livello_successo")
    private Integer livelloSuccesso;

    @Column(name = "commenti_finali", columnDefinition = "TEXT")
    private String commentiFinali;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Builder.Default
    @OneToMany(mappedBy = "missione", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MissioneOperatore> missioneOperatori = new HashSet<>();

    @Builder.Default
    @OneToMany(mappedBy = "missione", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MissioneMezzo> missioniMezzi = new HashSet<>();

    @Builder.Default
    @OneToMany(mappedBy = "missione", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MissioneMateriale> missioniMateriali = new HashSet<>();

    @Builder.Default
    @OneToMany(mappedBy = "missione", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<AggiornamentoMissione> aggiornamenti = new HashSet<>();

    public enum StatoMissione {
        IN_CORSO, CHIUSA, FALLITA
    }
}
