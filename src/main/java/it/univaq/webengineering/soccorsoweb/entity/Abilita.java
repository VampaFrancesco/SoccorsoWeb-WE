package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "abilita")
@Data
public class Abilita {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String nome;

    @Column(columnDefinition = "TEXT")
    private String descrizione;

}
