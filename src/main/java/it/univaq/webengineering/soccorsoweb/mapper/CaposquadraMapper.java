package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.CaposquadraRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.CaposquadraResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Caposquadra;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring", uses = { UserMapper.class })
public interface CaposquadraMapper {

    // ========== Request → Entity ==========
    // userId viene gestito dal service layer
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "utente", ignore = true)
    Caposquadra toEntity(CaposquadraRequest request);

    // ========== Entity → Response ==========
    CaposquadraResponse toResponse(Caposquadra entity);

    // ========== List mapping ==========
    List<CaposquadraResponse> toResponseList(List<Caposquadra> entities);
}
