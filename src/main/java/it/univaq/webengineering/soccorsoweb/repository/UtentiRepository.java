package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.Utenti;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface UtentiRepository extends JpaRepository<Utenti, Long> {

    Optional<Utenti> findByEmail(String email);
}
