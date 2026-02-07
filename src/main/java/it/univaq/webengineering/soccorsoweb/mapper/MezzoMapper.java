package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.MezzoRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MezzoResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Mezzo;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MezzoMapper {

    // ========== Request → Entity ==========
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "disponibile", defaultValue = "true")
    Mezzo toEntity(MezzoRequest request);

    // ========== Update Entity from Request ==========
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    void updateEntityFromDto(MezzoRequest request, @MappingTarget Mezzo entity);

    // ========== Entity → Response ==========
    MezzoResponse toResponse(Mezzo entity);

    // ========== List mapping ==========
    List<MezzoResponse> toResponseList(List<Mezzo> entities);
}
