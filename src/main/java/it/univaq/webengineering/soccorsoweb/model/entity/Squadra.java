package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "squadra", indexes = {
        @Index(name = "idx_caposquadra", columnList = "caposquadra_id"),
        @Index(name = "idx_attiva", columnList = "attiva")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Squadra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(columnDefinition = "TEXT")
    private String descrizione;

    @ManyToOne
    @JoinColumn(name = "caposquadra_id", nullable = false)
    private Caposquadra caposquadra;

    @Builder.Default
    @Column(nullable = false)
    private Boolean attiva = true;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relazione con gli operatori della squadra
    @Builder.Default
    @OneToMany(mappedBy = "squadra", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<SquadraOperatore> operatori = new HashSet<>();

}
