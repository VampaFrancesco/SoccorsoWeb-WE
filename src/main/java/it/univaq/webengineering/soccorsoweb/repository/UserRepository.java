package it.univaq.webengineering.soccorsoweb.repository;

import it.univaq.webengineering.soccorsoweb.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    Optional<Object> findByEmailAndPassword(String email, String password);

    /**
     * Trova operatori disponibili considerando:
     * 1. Il campo disponibile dell'utente
     * 2. Se disponibile=true, esclude operatori impegnati in missioni IN_CORSO
     */
    @Query("SELECT DISTINCT u FROM User u " +
            "JOIN u.roles r " +
            "WHERE r.name = 'OPERATORE' " +
            "AND u.attivo = true " +
            "AND (:disponibile = false OR u.id NOT IN " +
            "      (SELECT mo.operatore.id FROM MissioneOperatore mo WHERE mo.missione.stato = 'IN_CORSO'))")
    List<User> findOperatoriByDisponibile(@Param("disponibile") boolean disponibile);

}
