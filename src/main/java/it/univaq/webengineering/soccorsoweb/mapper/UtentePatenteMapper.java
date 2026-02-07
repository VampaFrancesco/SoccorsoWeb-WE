package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.response.UtentePatenteResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.UtentePatente;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring", uses = { PatenteMapper.class })
public interface UtentePatenteMapper {

    // ========== Entity → Response ==========
    @Mapping(target = "userId", source = "utente.id")
    @Mapping(target = "patenteId", source = "patente.id")
    @Mapping(target = "patente", source = "patente")
    UtentePatenteResponse toResponse(UtentePatente entity);

    // ========== List mapping ==========
    List<UtentePatenteResponse> toResponseList(List<UtentePatente> entities);
}
