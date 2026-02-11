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

    // Mappa Set<UtenteAbilita> a Set<AbilitaResponse>
    default java.util.Set<AbilitaResponse> map(
            java.util.Set<it.univaq.webengineering.soccorsoweb.model.entity.UtenteAbilita> value) {
        if (value == null) {
            return null;
        }
        return value.stream()
                .map(ua -> {
                    AbilitaResponse response = toResponse(ua.getAbilita());
                    if (ua.getLivello() != null) {
                        response.setLivello(ua.getLivello());
                    }
                    return response;
                })
                .collect(java.util.stream.Collectors.toSet());
    }

    // ========== List mapping ==========
    List<AbilitaResponse> toResponseList(List<Abilita> entities);
}
