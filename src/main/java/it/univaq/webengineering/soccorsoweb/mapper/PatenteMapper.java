package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.response.PatenteResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Patente;
import it.univaq.webengineering.soccorsoweb.model.entity.UtentePatente;
import org.mapstruct.Mapper;

import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface PatenteMapper {

    PatenteResponse toResponse(Patente patente);

    // Mappa Set<UtentePatente> a Set<PatenteResponse> estraendo la patente
    // dall'entità di relazione
    default Set<PatenteResponse> map(Set<UtentePatente> value) {
        if (value == null) {
            return null;
        }
        return value.stream()
                .map(utentePatente -> toResponse(utentePatente.getPatente()))
                .collect(Collectors.toSet());
    }
}
