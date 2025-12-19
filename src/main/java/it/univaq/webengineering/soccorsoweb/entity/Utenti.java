package it.univaq.webengineering.soccorsoweb.entity;


import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;
import java.sql.Date;
import java.time.LocalDateTime;

@Entity
@Table(name="utenti")
@Data
public class Utenti {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private int id;

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
