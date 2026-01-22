package it.univaq.webengineering.soccorsoweb.model.entity;


import jakarta.persistence.*;
import lombok.Data;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name="utenti")
@Data
public class Utenti {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;

    @Column(length=255)
    private String email;

    @Column(length=255)
    private String password;

    @Column(length=100)
    private String nome;

    @Column(length=100)
    private String cognome;

    @Column
    private Date dataNascita;

    @Column(length=20)
    private String telefono;

    @Column(length=255)
    private String indirizzo;

    @Column
    private boolean attivo;

    @Column
    private LocalDateTime created_at;

    @Column
    private LocalDateTime updated_at;

    // Relazione One-to-Many con MissioneOperatore (l'utente può essere assegnato a più missioni come operatore)
    @OneToMany(mappedBy = "operatore", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MissioneOperatore> missioniOperatore = new HashSet<>();

    // Relazione One-to-Many con AggiornamentoMissione (l'utente admin può creare più aggiornamenti)
    @OneToMany(mappedBy = "admin", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<AggiornamentoMissione> aggiornamenti = new HashSet<>();

    // Relazione One-to-One con Caposquadra (un utente può essere un caposquadra)
    @OneToOne(mappedBy = "utente", cascade = CascadeType.ALL, orphanRemoval = true)
    private Caposquadra caposquadra;

    // Relazione One-to-Many con SquadreOperatori (un utente può essere in più squadre)
    @OneToMany(mappedBy = "utente", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<SquadreOperatori> squadreOperatori = new HashSet<>();

    // Relazione One-to-Many con UtentiAbilita (un utente può avere più abilità)
    @OneToMany(mappedBy = "utente", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<UtentiAbilita> utentiAbilita = new HashSet<>();

    // Relazione One-to-Many con UtentiPatenti (un utente può avere più patenti)
    @OneToMany(mappedBy = "utenti", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<UtentiPatenti> utentiPatenti = new HashSet<>();

    // Relazione One-to-Many con UtentiRuoli (un utente può avere più ruoli)
    @OneToMany(mappedBy = "utenti", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<UtentiRuoli> utentiRuoli = new HashSet<>();

    @PrePersist
    public void prePersist()
    {
        this.created_at = LocalDateTime.now();
        this.updated_at = LocalDateTime.now();
    }

    @PreUpdate
    public void preUpdate()
    {
        this.updated_at = LocalDateTime.now();
    }

}
