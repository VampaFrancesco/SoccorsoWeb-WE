package it.univaq.webengineering.soccorsoweb.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class SquadreOperatoriId implements Serializable {

    @Column(name = "squadra_id")
    private Long squadraId;

    @Column(name = "utente_id")
    private Long utenteId;

    public SquadreOperatoriId() {}

    public SquadreOperatoriId(Long squadraId, Long utenteId) {
        this.squadraId = squadraId;
        this.utenteId = utenteId;
    }

    public Long getSquadraId() { return squadraId; }
    public void setSquadraId(Long squadraId) { this.squadraId = squadraId; }

    public Long getUtenteId() { return utenteId; }
    public void setUtenteId(Long utenteId) { this.utenteId = utenteId; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof SquadreOperatoriId)) return false;
        SquadreOperatoriId that = (SquadreOperatoriId) o;
        return Objects.equals(squadraId, that.squadraId) &&
                Objects.equals(utenteId, that.utenteId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(squadraId, utenteId);
    }
}
