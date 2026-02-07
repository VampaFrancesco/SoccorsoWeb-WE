package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.response.MissioneOperatoreResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.MissioneOperatore;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring", uses = { UserMapper.class })
public interface MissioneOperatoreMapper {

    // ========== Entity → Response ==========
    @Mapping(target = "missioneId", source = "missione.id")
    @Mapping(target = "operatoreId", source = "operatore.id")
    @Mapping(target = "operatore", source = "operatore")
    MissioneOperatoreResponse toResponse(MissioneOperatore entity);

    // ========== List mapping ==========
    List<MissioneOperatoreResponse> toResponseList(List<MissioneOperatore> entities);
}
