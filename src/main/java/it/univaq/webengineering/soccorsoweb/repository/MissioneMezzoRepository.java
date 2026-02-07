package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.MissioneMezzo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MissioneMezzoRepository extends JpaRepository<MissioneMezzo, MissioneMezzo.MissioneMezzoId> {
}
