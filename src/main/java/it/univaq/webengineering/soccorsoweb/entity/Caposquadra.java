package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "caposquadra")
public class Caposquadra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "utente_id", nullable = false, unique = true)
    private Utente utente;

    public Caposquadra() {}

    public Caposquadra(Utente utente) {
        this.utente = utente;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Utente getUtente() { return utente; }
    public void setUtente(Utente utente) { this.utente = utente; }
}
