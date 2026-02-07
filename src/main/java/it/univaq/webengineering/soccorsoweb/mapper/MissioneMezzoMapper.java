package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.response.MissioneMezzoResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.MissioneMezzo;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring", uses = { MezzoMapper.class })
public interface MissioneMezzoMapper {

    // ========== Entity → Response ==========
    @Mapping(target = "missioneId", source = "missione.id")
    @Mapping(target = "mezzoId", source = "mezzo.id")
    @Mapping(target = "mezzo", source = "mezzo")
    MissioneMezzoResponse toResponse(MissioneMezzo entity);

    // ========== List mapping ==========
    List<MissioneMezzoResponse> toResponseList(List<MissioneMezzo> entities);
}
