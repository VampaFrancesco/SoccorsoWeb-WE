package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "caposquadra")
@Data
public class Caposquadra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "utente_id", nullable = false, unique = true)
    private Utenti utente;

    // Relazione One-to-Many con Squadra (un caposquadra può avere più squadre)
    @OneToMany(mappedBy = "caposquadra", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Squadra> squadre = new HashSet<>();

    // Relazione One-to-Many con Missione (un caposquadra può avere più missioni assegnate)
    @OneToMany(mappedBy = "caposquadra", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Missione> missioni = new HashSet<>();

}
