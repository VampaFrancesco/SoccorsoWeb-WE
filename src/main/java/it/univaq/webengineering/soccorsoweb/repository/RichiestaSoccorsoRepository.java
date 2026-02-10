package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.RichiestaSoccorso;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface RichiestaSoccorsoRepository extends JpaRepository<RichiestaSoccorso, Long> {

    /** Query paginata per stato */
    Page<RichiestaSoccorso> findByStato(RichiestaSoccorso.StatoRichiesta stato, Pageable pageable);

    /** Trova richiesta tramite token di convalida */
    RichiestaSoccorso findByTokenConvalida(String tokenConvalida);

    /** Conta le richieste dallo stesso IP dopo una certa data (anti-spam) */
    long countByIpOrigineAndCreatedAtAfter(String ipOrigine, LocalDateTime after);
}
