package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entity che rappresenta un Mezzo di soccorso
 */
@Entity
@Table(name = "mezzi", indexes = {
        @Index(name = "idx_disponibile", columnList = "disponibile"),
        @Index(name = "idx_tipo", columnList = "tipo")
})
@Data
public class Mezzo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(columnDefinition = "TEXT")
    private String descrizione;

    @Column(length = 50)
    private String tipo;

    @Column(length = 20)
    private String targa;

    @Column(nullable = false)
    private Boolean disponibile = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relazione Many-to-Many con Missione attraverso MissioneMezzo
    @OneToMany(mappedBy = "mezzo", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MissioneMezzo> missioniMezzi = new HashSet<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}

