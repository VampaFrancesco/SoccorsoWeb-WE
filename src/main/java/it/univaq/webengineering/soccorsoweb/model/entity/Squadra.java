package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "squadre")
@Data
public class Squadra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(columnDefinition = "TEXT")
    private String descrizione;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "caposquadra_id", nullable = false)
    private Caposquadra caposquadra;

    @Column(nullable = false)
    private Boolean attiva = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relazione One-to-Many con Missione (una squadra può avere più missioni)
    @OneToMany(mappedBy = "squadra", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Missione> missioni = new HashSet<>();

    // Relazione One-to-Many con SquadreOperatori (una squadra può avere più operatori)
    @OneToMany(mappedBy = "squadra", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<SquadreOperatori> squadreOperatori = new HashSet<>();

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
