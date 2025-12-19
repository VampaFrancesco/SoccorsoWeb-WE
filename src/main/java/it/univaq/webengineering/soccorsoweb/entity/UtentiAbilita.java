package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "utenti_abilita")
public class UtentiAbilita {

    @EmbeddedId
    private UtentiAbilitaId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("utenteId")
    @JoinColumn(name = "utente_id")
    private Utente utente;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("abilitaId")
    @JoinColumn(name = "abilita_id")
    private Abilita abilita;

    @Column(length = 50)
    private String livello;

    public UtentiAbilita() {}

    public UtentiAbilita(Utente utente, Abilita abilita, String livello) {
        this.utente = utente;
        this.abilita = abilita;
        this.livello = livello;
        this.id = new UtentiAbilitaId(utente.getId(), abilita.getId());
    }

    public UtentiAbilitaId getId() { return id; }
    public void setId(UtentiAbilitaId id) { this.id = id; }

    public Utente getUtente() { return utente; }
    public void setUtente(Utente utente) { this.utente = utente; }

    public Abilita getAbilita() { return abilita; }
    public void setAbilita(Abilita abilita) { this.abilita = abilita; }

    public String getLivello() { return livello; }
    public void setLivello(String livello) { this.livello = livello; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UtentiAbilita)) return false;
        UtentiAbilita that = (UtentiAbilita) o;
        return Objects.equals(utente, that.utente) &&
                Objects.equals(abilita, that.abilita);
    }

    @Override
    public int hashCode() {
        return Objects.hash(utente, abilita);
    }
}
