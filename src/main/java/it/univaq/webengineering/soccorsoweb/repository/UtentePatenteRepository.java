package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.UtentePatente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UtentePatenteRepository extends JpaRepository<UtentePatente, UtentePatente.UtentePatenteId> {
}
