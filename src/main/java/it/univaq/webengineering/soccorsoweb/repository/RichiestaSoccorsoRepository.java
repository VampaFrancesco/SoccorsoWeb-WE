package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.RichiestaSoccorso;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

import org.springframework.stereotype.Repository;

@Repository
public interface RichiestaSoccorsoRepository extends JpaRepository<RichiestaSoccorso, Long> {

    /**
     * Query paginata per stato
     * Spring Data JPA genera automaticamente:
     * SELECT * FROM richiesta_soccorso WHERE stato = :stato LIMIT :size OFFSET :offset
     */
    Page<RichiestaSoccorso> findByStato(RichiestaSoccorso.StatoRichiesta stato, Pageable pageable);

    RichiestaSoccorso findByTokenConvalida(String tokenConvalida);
}
