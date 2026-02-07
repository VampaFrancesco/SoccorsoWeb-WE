package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.AggiornamentoMissioneRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.AggiornamentoMissioneResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.AggiornamentoMissione;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring", uses = { UserMapper.class })
public interface AggiornamentoMissioneMapper {

    // ========== Request → Entity ==========
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "missione", ignore = true)
    @Mapping(target = "admin", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    AggiornamentoMissione toEntity(AggiornamentoMissioneRequest request);

    // ========== Entity → Response ==========
    @Mapping(target = "missioneId", source = "missione.id")
    @Mapping(target = "admin", source = "admin")
    AggiornamentoMissioneResponse toResponse(AggiornamentoMissione entity);

    // ========== List mapping ==========
    List<AggiornamentoMissioneResponse> toResponseList(List<AggiornamentoMissione> entities);
}
