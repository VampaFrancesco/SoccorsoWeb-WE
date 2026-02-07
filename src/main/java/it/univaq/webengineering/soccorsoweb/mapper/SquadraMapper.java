package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.SquadraRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.SquadraResponse;
import it.univaq.webengineering.soccorsoweb.model.dto.response.SquadraOperatoreResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Squadra;
import it.univaq.webengineering.soccorsoweb.model.entity.SquadraOperatore;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", uses = { UserMapper.class })
public interface SquadraMapper {

    // ========== Request → Entity ==========
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "caposquadra", ignore = true)
    @Mapping(target = "attiva", constant = "true")
    @Mapping(target = "operatori", ignore = true)
    Squadra toEntity(SquadraRequest request);

    // ========== Entity → Response ==========
    @Mapping(target = "caposquadra", source = "caposquadra.utente")
    @Mapping(target = "operatori", expression = "java(mapSquadraOperatoriToResponse(entity))")
    SquadraResponse toResponse(Squadra entity);

    // ========== List mapping ==========
    List<SquadraResponse> toResponseList(List<Squadra> entities);

    // ========== Helper methods ==========
    @Named("mapSquadraOperatoriToResponse")
    default Set<SquadraOperatoreResponse> mapSquadraOperatoriToResponse(Squadra squadra) {
        if (squadra == null || squadra.getOperatori() == null) {
            return new HashSet<>();
        }

        return squadra.getOperatori().stream()
                .map(so -> {
                    SquadraOperatoreResponse response = new SquadraOperatoreResponse();
                    response.setSquadraId(squadra.getId());
                    response.setUserId(so.getOperatore() != null ? so.getOperatore().getId() : null);
                    response.setRuolo(so.getRuolo());
                    response.setAssegnatoIl(so.getAssegnatoIl());
                    // Non mappiamo l'intero operatore per evitare lazy loading issues
                    return response;
                })
                .collect(Collectors.toSet());
    }
}
