package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.MissioneRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.*;
import it.univaq.webengineering.soccorsoweb.model.entity.*;
import org.mapstruct.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", uses = { UserMapper.class, RichiestaSoccorsoMapper.class, SquadraMapper.class })
public interface MissioneMapper {

    // ========== Request → Entity ==========
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "richiesta", ignore = true)
    @Mapping(target = "caposquadra", ignore = true)
    @Mapping(target = "squadra", ignore = true)
    @Mapping(target = "missioneOperatori", ignore = true)
    @Mapping(target = "missioniMezzi", ignore = true)
    @Mapping(target = "missioniMateriali", ignore = true)
    @Mapping(target = "aggiornamenti", ignore = true)
    @Mapping(target = "livelloSuccesso", ignore = true)
    @Mapping(target = "stato", constant = "IN_CORSO")
    @Mapping(target = "inizioAt", expression = "java(java.time.LocalDateTime.now())")
    @Mapping(target = "fineAt", ignore = true)
    @Mapping(target = "commentiFinali", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    Missione toEntity(MissioneRequest request);

    // ========== Entity → Response ==========
    @Mapping(target = "richiestaId", source = "richiesta.id")
    @Mapping(target = "richiesta", source = "richiesta")
    @Mapping(target = "squadra", source = "squadra")
    @Mapping(target = "caposquadra", source = "caposquadra.utente")
    @Mapping(target = "livelloSuccesso", source = "livelloSuccesso")
    @Mapping(target = "commentiFinali", source = "commentiFinali")
    @Mapping(target = "fineAt", source = "fineAt")
    @Mapping(target = "numeroOperatori", expression = "java(entity.getMissioneOperatori() != null ? entity.getMissioneOperatori().size() : 0)")
    @Mapping(target = "operatori", expression = "java(mapMissioneOperatoriToUsers(entity))")
    @Mapping(target = "mezzi", expression = "java(mapMissioneMezziToResponse(entity))")
    @Mapping(target = "materiali", expression = "java(mapMissioneMaterialiToResponse(entity))")
    @Mapping(target = "aggiornamenti", expression = "java(mapAggiornamentiToResponse(entity))")
    MissioneResponse toResponse(Missione entity);

    // ========== List mapping ==========
    List<MissioneResponse> toResponseList(List<Missione> entities);

    // ========== Helper methods ==========
    @Named("mapMissioneOperatoriToUsers")
    default Set<UserResponse> mapMissioneOperatoriToUsers(Missione missione) {
        if (missione == null || missione.getMissioneOperatori() == null) {
            return new HashSet<>();
        }

        return missione.getMissioneOperatori().stream()
                .filter(mo -> mo.getOperatore() != null)
                .map(mo -> {
                    UserResponse response = new UserResponse();
                    response.setId(mo.getOperatore().getId());
                    response.setEmail(mo.getOperatore().getEmail());
                    response.setNome(mo.getOperatore().getNome());
                    response.setCognome(mo.getOperatore().getCognome());
                    response.setDataNascita(mo.getOperatore().getDataNascita());
                    response.setTelefono(mo.getOperatore().getTelefono());
                    response.setIndirizzo(mo.getOperatore().getIndirizzo());
                    response.setAttivo(mo.getOperatore().getAttivo());
                    response.setCreatedAt(mo.getOperatore().getCreatedAt());
                    response.setUpdatedAt(mo.getOperatore().getUpdatedAt());
                    response.setRoles(new HashSet<>());
                    return response;
                })
                .collect(Collectors.toSet());
    }

    @Named("mapMissioneMezziToResponse")
    default Set<MezzoResponse> mapMissioneMezziToResponse(Missione missione) {
        if (missione == null || missione.getMissioniMezzi() == null) {
            return new HashSet<>();
        }

        return missione.getMissioniMezzi().stream()
                .filter(mm -> mm.getMezzo() != null)
                .map(mm -> {
                    MezzoResponse response = new MezzoResponse();
                    response.setId(mm.getMezzo().getId());
                    response.setNome(mm.getMezzo().getNome());
                    response.setDescrizione(mm.getMezzo().getDescrizione());
                    response.setTipo(mm.getMezzo().getTipo());
                    response.setTarga(mm.getMezzo().getTarga());
                    response.setDisponibile(mm.getMezzo().getDisponibile());
                    response.setCreatedAt(mm.getMezzo().getCreatedAt());
                    response.setUpdatedAt(mm.getMezzo().getUpdatedAt());
                    return response;
                })
                .collect(Collectors.toSet());
    }

    @Named("mapMissioneMaterialiToResponse")
    default Set<MaterialeResponse> mapMissioneMaterialiToResponse(Missione missione) {
        if (missione == null || missione.getMissioniMateriali() == null) {
            return new HashSet<>();
        }

        return missione.getMissioniMateriali().stream()
                .filter(mm -> mm.getMateriale() != null)
                .map(mm -> {
                    MaterialeResponse response = new MaterialeResponse();
                    response.setId(mm.getMateriale().getId());
                    response.setNome(mm.getMateriale().getNome());
                    response.setDescrizione(mm.getMateriale().getDescrizione());
                    response.setTipo(mm.getMateriale().getTipo());
                    response.setQuantita(mm.getQuantitaUsata()); // Usa quantità assegnata
                    response.setDisponibile(mm.getMateriale().getDisponibile());
                    response.setCreatedAt(mm.getMateriale().getCreatedAt());
                    response.setUpdatedAt(mm.getMateriale().getUpdatedAt());
                    return response;
                })
                .collect(Collectors.toSet());
    }

    @Named("mapAggiornamentiToResponse")
    default Set<AggiornamentoMissioneResponse> mapAggiornamentiToResponse(Missione missione) {
        if (missione == null || missione.getAggiornamenti() == null) {
            return new HashSet<>();
        }

        return missione.getAggiornamenti().stream()
                .map(agg -> {
                    AggiornamentoMissioneResponse response = new AggiornamentoMissioneResponse();
                    response.setId(agg.getId());
                    response.setMissioneId(missione.getId());
                    response.setDescrizione(agg.getDescrizione());
                    response.setCreatedAt(agg.getCreatedAt());
                    if (agg.getAdmin() != null) {
                        UserResponse adminResponse = new UserResponse();
                        adminResponse.setId(agg.getAdmin().getId());
                        adminResponse.setEmail(agg.getAdmin().getEmail());
                        adminResponse.setNome(agg.getAdmin().getNome());
                        adminResponse.setCognome(agg.getAdmin().getCognome());
                        response.setAdmin(adminResponse);
                    }
                    return response;
                })
                .collect(Collectors.toSet());
    }
}
