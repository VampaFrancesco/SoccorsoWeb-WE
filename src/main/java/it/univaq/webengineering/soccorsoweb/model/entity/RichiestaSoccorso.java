package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "richiesta_soccorso", indexes = {
        @Index(name = "idx_email_segnalante", columnList = "email_segnalante"),
        @Index(name = "idx_stato", columnList = "stato"),
        @Index(name = "idx_token", columnList = "token_convalida")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RichiestaSoccorso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String descrizione;

    @Column(nullable = false)
    private String indirizzo;

    @Column(precision = 10, scale = 8)
    private BigDecimal latitudine;

    @Column(precision = 11, scale = 8)
    private BigDecimal longitudine;

    @Column(name = "nome_segnalante", nullable = false, length = 100)
    private String nomeSegnalante;

    @Column(name = "email_segnalante", nullable = false)
    private String emailSegnalante;

    @Column(name = "telefono_segnalante", length = 20)
    private String telefonoSegnalante;

    @Lob
    @Column(name = "foto")
    private java.sql.Blob foto;

    @Column(name = "ip_origine", length = 45)
    private String ipOrigine;

    @Column(name = "token_convalida", unique = true)
    private String tokenConvalida;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatoRichiesta stato;

    @Column(name = "convalidata_at")
    private LocalDateTime convalidataAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relazione One-to-One con Missione
    @OneToOne(mappedBy = "richiesta")
    private Missione missione;

    // Enum per lo stato
    public enum StatoRichiesta {
        ATTIVA,       // Convalidata, in attesa di gestione
        IN_CORSO,     // Missione assegnata e in corso
        CHIUSA,       // Missione completata
        IGNORATA      // Richiesta annullata o ignorata
    }
}
