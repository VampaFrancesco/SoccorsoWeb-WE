package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entity che rappresenta una Missione di soccorso
 */
@Entity
@Table(name = "missioni", indexes = {
        @Index(name = "idx_stato", columnList = "stato"),
        @Index(name = "idx_caposquadra", columnList = "caposquadra_id"),
        @Index(name = "idx_squadra", columnList = "squadra_id"),
        @Index(name = "idx_richiesta", columnList = "richiesta_id")
})
@Data
public class Missione {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "richiesta_id", nullable = false, unique = true)
    private RichiestaSoccorso richiestaSoccorso;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "squadra_id")
    private Squadra squadra;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "caposquadra_id", nullable = false)
    private Caposquadra caposquadra;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String obiettivo;

    @Column(length = 255)
    private String posizione;

    @Column(precision = 10, scale = 8)
    private BigDecimal latitudine;

    @Column(precision = 11, scale = 8)
    private BigDecimal longitudine;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private StatoMissione stato = StatoMissione.IN_CORSO;

    @Column(name = "inizio_at")
    private LocalDateTime inizioAt;

    @Column(name = "fine_at")
    private LocalDateTime fineAt;

    @Column(name = "livello_successo")
    private Integer livelloSuccesso;

    @Column(name = "commenti_finali", columnDefinition = "TEXT")
    private String commentiFinali;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relazioni Many-to-Many
    @OneToMany(mappedBy = "missione", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MissioneOperatore> missioniOperatori = new HashSet<>();

    @OneToMany(mappedBy = "missione", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MissioneMezzo> missioniMezzi = new HashSet<>();

    @OneToMany(mappedBy = "missione", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MissioneMateriale> missioniMateriali = new HashSet<>();

    // Relazione One-to-Many con AggiornamentoMissione
    @OneToMany(mappedBy = "missione", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<AggiornamentoMissione> aggiornamenti = new HashSet<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    /**
     * Enum per lo stato della missione
     */
    public enum StatoMissione {
        IN_CORSO,
        CHIUSA,
        FALLITA
    }
}

