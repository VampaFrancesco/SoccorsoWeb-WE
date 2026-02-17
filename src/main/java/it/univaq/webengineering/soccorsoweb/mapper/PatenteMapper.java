package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.response.PatenteResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Patente;
import it.univaq.webengineering.soccorsoweb.model.entity.UtentePatente;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface PatenteMapper {

    @Mapping(target = "id", source = "patente.id")
    @Mapping(target = "tipo", source = "patente.tipo")
    @Mapping(target = "descrizione", source = "patente.descrizione")
    @Mapping(target = "conseguitaIl", source = "conseguitaIl")
    @Mapping(target = "rilasciataDa", source = "rilasciataDa")
    PatenteResponse toResponse(UtentePatente utentePatente);

    PatenteResponse toResponse(Patente patente);

    // Mappa Set<UtentePatente> a Set<PatenteResponse> includendo i campi della
    // relazione
    default Set<PatenteResponse> map(Set<UtentePatente> value) {
        if (value == null) {
            return null;
        }
        return value.stream()
                .map(this::toResponse)
                .collect(Collectors.toSet());
    }
}
