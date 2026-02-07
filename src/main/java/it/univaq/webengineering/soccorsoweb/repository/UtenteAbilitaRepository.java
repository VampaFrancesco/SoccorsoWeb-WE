package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.UtenteAbilita;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UtenteAbilitaRepository extends JpaRepository<UtenteAbilita, UtenteAbilita.UtenteAbilitaId> {
}
