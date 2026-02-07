package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.SquadraOperatore;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SquadraOperatoreRepository
        extends JpaRepository<SquadraOperatore, SquadraOperatore.SquadraOperatoreId> {
}
