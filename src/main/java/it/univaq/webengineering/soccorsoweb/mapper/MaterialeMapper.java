package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.MaterialeRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.MaterialeResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Materiale;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MaterialeMapper {

    // ========== Request → Entity ==========
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "disponibile", defaultValue = "true")
    @Mapping(target = "quantita", defaultValue = "0")
    Materiale toEntity(MaterialeRequest request);

    // ========== Update Entity from Request ==========
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    void updateEntityFromDto(MaterialeRequest request, @MappingTarget Materiale entity);

    // ========== Entity → Response ==========
    MaterialeResponse toResponse(Materiale entity);

    // ========== List mapping ==========
    List<MaterialeResponse> toResponseList(List<Materiale> entities);
}
