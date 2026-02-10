package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.Materiale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MaterialeRepository extends JpaRepository<Materiale, Long> {
    List<Materiale> findByDisponibileTrue();
}
