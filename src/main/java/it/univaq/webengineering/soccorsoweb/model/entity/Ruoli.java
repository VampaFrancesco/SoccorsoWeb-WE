package it.univaq.webengineering.soccorsoweb.model.entity;


import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name="ruoli")
@Data
public class Ruoli {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;

    @Column(length=50)
    private String nome;

}
