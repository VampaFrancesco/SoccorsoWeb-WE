package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.Missione;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MissioneRepository extends JpaRepository<Missione, Long> {

    @Query("SELECT mo.missione FROM MissioneOperatore mo WHERE mo.operatore.id = :id")
    List<Missione> findAllByOperatoreId(Long id);
}
