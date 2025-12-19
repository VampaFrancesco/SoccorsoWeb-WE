package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class UtentiAbilitaId implements Serializable {

    @Column(name = "utente_id")
    private Long utenteId;

    @Column(name = "abilita_id")
    private Long abilitaId;

    public UtentiAbilitaId() {}

    public UtentiAbilitaId(Long utenteId, Long abilitaId) {
        this.utenteId = utenteId;
        this.abilitaId = abilitaId;
    }

    public Long getUtenteId() { return utenteId; }
    public void setUtenteId(Long utenteId) { this.utenteId = utenteId; }

    public Long getAbilitaId() { return abilitaId; }
    public void setAbilitaId(Long abilitaId) { this.abilitaId = abilitaId; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UtentiAbilitaId)) return false;
        UtentiAbilitaId that = (UtentiAbilitaId) o;
        return Objects.equals(utenteId, that.utenteId) &&
                Objects.equals(abilitaId, that.abilitaId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(utenteId, abilitaId);
    }
}
