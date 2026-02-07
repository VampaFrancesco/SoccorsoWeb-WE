package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "user_abilita", indexes = {
        @Index(name = "idx_abilita_id", columnList = "abilita_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UtenteAbilita {

    @EmbeddedId
    private UtenteAbilitaId id;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User utente;

    @ManyToOne
    @MapsId("abilitaId")
    @JoinColumn(name = "abilita_id")
    private Abilita abilita;

    @Column(length = 50)
    private String livello;

    @Embeddable
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class UtenteAbilitaId implements Serializable {
        @Column(name = "user_id")
        private Long userId;

        @Column(name = "abilita_id")
        private Long abilitaId;
    }
}
