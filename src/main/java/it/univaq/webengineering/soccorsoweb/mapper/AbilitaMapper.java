package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.AbilitaRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.AbilitaResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Abilita;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AbilitaMapper {

    // ========== Request → Entity ==========
    @Mapping(target = "id", ignore = true)
    Abilita toEntity(AbilitaRequest request);

    // ========== Entity → Response ==========
    AbilitaResponse toResponse(Abilita entity);

    // ========== List mapping ==========
    List<AbilitaResponse> toResponseList(List<Abilita> entities);
}
