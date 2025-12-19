package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.Objects;

@Entity
@Table(name = "squadre_operatori")
public class SquadreOperatori {

    @EmbeddedId
    private SquadreOperatoriId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("squadraId")
    @JoinColumn(name = "squadra_id")
    private Squadra squadra;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("utenteId")
    @JoinColumn(name = "utente_id")
    private Utente utente;

    @Column(length = 50)
    private String ruolo;

    @Column(name = "assegnato_il")
    private LocalDate assegnatoIl;

    public SquadreOperatori() {}

    public SquadreOperatori(Squadra squadra, Utente utente, String ruolo) {
        this.squadra = squadra;
        this.utente = utente;
        this.ruolo = ruolo;
        this.assegnatoIl = LocalDate.now();
        this.id = new SquadreOperatoriId(squadra.getId(), utente.getId());
    }

    public SquadreOperatoriId getId() { return id; }
    public void setId(SquadreOperatoriId id) { this.id = id; }

    public Squadra getSquadra() { return squadra; }
    public void setSquadra(Squadra squadra) { this.squadra = squadra; }

    public Utente getUtente() { return utente; }
    public void setUtente(Utente utente) { this.utente = utente; }

    public String getRuolo() { return ruolo; }
    public void setRuolo(String ruolo) { this.ruolo = ruolo; }

    public LocalDate getAssegnatoIl() { return assegnatoIl; }
    public void setAssegnatoIl(LocalDate assegnatoIl) { this.assegnatoIl = assegnatoIl; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof SquadreOperatori)) return false;
        SquadreOperatori that = (SquadreOperatori) o;
        return Objects.equals(squadra, that.squadra) &&
                Objects.equals(utente, that.utente);
    }

    @Override
    public int hashCode() {
        return Objects.hash(squadra, utente);
    }
}
