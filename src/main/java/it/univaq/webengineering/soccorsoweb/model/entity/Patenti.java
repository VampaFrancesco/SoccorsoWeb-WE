package it.univaq.webengineering.soccorsoweb.model.entity;


import jakarta.persistence.*;
import lombok.Data;


@Entity
@Table(name="patenti")
@Data
public class Patenti {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private int id;

    @Column(length=50)
    private String tipo;

    @Column(columnDefinition = "text")
    private String descrizione;

}
