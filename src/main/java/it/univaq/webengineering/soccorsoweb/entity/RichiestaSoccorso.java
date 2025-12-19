package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "richieste_soccorso")
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

    public RichiestaSoccorso() {}

    public RichiestaSoccorso(String descrizione, String indirizzo, String nomeSegnalante,
                             String emailSegnalante) {
        this.descrizione = descrizione;
        this.indirizzo = indirizzo;
        this.nomeSegnalante = nomeSegnalante;
        this.emailSegnalante = emailSegnalante;
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getDescrizione() { return descrizione; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }

    public String getIndirizzo() { return indirizzo; }
    public void setIndirizzo(String indirizzo) { this.indirizzo = indirizzo; }

    public BigDecimal getLatitudine() { return latitudine; }
    public void setLatitudine(BigDecimal latitudine) { this.latitudine = latitudine; }

    public BigDecimal getLongitudine() { return longitudine; }
    public void setLongitudine(BigDecimal longitudine) { this.longitudine = longitudine; }

    public String getNomeSegnalante() { return nomeSegnalante; }
    public void setNomeSegnalante(String nomeSegnalante) { this.nomeSegnalante = nomeSegnalante; }

    public String getEmailSegnalante() { return emailSegnalante; }
    public void setEmailSegnalante(String emailSegnalante) { this.emailSegnalante = emailSegnalante; }

    public String getTelefonoSegnalante() { return telefonoSegnalante; }
    public void setTelefonoSegnalante(String telefonoSegnalante) { this.telefonoSegnalante = telefonoSegnalante; }

    public String getFotoUrl() { return fotoUrl; }
    public void setFotoUrl(String fotoUrl) { this.fotoUrl = fotoUrl; }

    public String getIpOrigine() { return ipOrigine; }
    public void setIpOrigine(String ipOrigine) { this.ipOrigine = ipOrigine; }

    public String getTokenConvalida() { return tokenConvalida; }
    public void setTokenConvalida(String tokenConvalida) { this.tokenConvalida = tokenConvalida; }

    public StatoRichiesta getStato() { return stato; }
    public void setStato(StatoRichiesta stato) { this.stato = stato; }

    public LocalDateTime getConvalidataAt() { return convalidataAt; }
    public void setConvalidataAt(LocalDateTime convalidataAt) { this.convalidataAt = convalidataAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public enum StatoRichiesta {
        INVIATA,
        ATTIVA,
        IN_CORSO,
        CHIUSA,
        IGNORATA
    }
}
