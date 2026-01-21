package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "richieste_soccorso")
@Data
public class RichiestaSoccorso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String descrizione;

    @Column(nullable = false, length = 255)
    private String indirizzo;

    @Column(precision = 10, scale = 8)
    private BigDecimal latitudine;

    @Column(precision = 11, scale = 8)
    private BigDecimal longitudine;

    @Column(name = "nome_segnalante", nullable = false, length = 100)
    private String nomeSegnalante;

    @Column(name = "email_segnalante", nullable = false, length = 255)
    private String emailSegnalante;

    @Column(name = "telefono_segnalante", length = 20)
    private String telefonoSegnalante;

    @Column(name = "foto_url", length = 255)
    private String fotoUrl;

    @Column(name = "ip_origine", length = 45)
    private String ipOrigine;

    @Column(name = "token_convalida", unique = true, length = 255)
    private String tokenConvalida;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatoRichiesta stato = StatoRichiesta.INVIATA;

    @Column(name = "convalidata_at")
    private LocalDateTime convalidataAt;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relazione One-to-One con Missione (una richiesta può generare una missione)
    @OneToOne(mappedBy = "richiestaSoccorso", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Missione missione;


    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public enum StatoRichiesta {
        INVIATA,
        ATTIVA,
        IN_CORSO,
        CHIUSA,
        IGNORATA
    }
}
