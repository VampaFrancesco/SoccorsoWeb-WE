package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.Mezzo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MezzoRepository extends JpaRepository<Mezzo, Long> {
    List<Mezzo> findByDisponibileTrue();
}
