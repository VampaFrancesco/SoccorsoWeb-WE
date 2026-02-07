package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.PatenteRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.PatenteResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Patente;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface PatenteMapper {

    // ========== Request → Entity ==========
    @Mapping(target = "id", ignore = true)
    Patente toEntity(PatenteRequest request);

    // ========== Entity → Response ==========
    PatenteResponse toResponse(Patente entity);

    // ========== List mapping ==========
    List<PatenteResponse> toResponseList(List<Patente> entities);
}
