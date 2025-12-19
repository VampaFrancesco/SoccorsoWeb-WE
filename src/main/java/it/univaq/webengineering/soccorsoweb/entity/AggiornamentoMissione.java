package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * Entity che rappresenta un Aggiornamento di una Missione
 */
@Entity
@Table(name = "aggiornamenti_missioni", indexes = {
        @Index(name = "idx_missione", columnList = "missione_id"),
        @Index(name = "idx_admin", columnList = "admin_id"),
        @Index(name = "idx_created", columnList = "created_at")
})
@Data
public class AggiornamentoMissione {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "missione_id", nullable = false)
    private Missione missione;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "admin_id", nullable = false)
    private Utenti admin;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String descrizione;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

}

