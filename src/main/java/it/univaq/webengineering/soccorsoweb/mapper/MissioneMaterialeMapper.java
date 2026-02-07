package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.response.MissioneMaterialeResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.MissioneMateriale;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring", uses = { MaterialeMapper.class })
public interface MissioneMaterialeMapper {

    // ========== Entity → Response ==========
    @Mapping(target = "missioneId", source = "missione.id")
    @Mapping(target = "materialeId", source = "materiale.id")
    @Mapping(target = "materiale", source = "materiale")
    MissioneMaterialeResponse toResponse(MissioneMateriale entity);

    // ========== List mapping ==========
    List<MissioneMaterialeResponse> toResponseList(List<MissioneMateriale> entities);
}
