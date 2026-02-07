package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.AggiornamentoMissione;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AggiornamentoMissioneRepository extends JpaRepository<AggiornamentoMissione, Long> {
}
