package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.UserUpdateRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.UserRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.UserResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.User;
import org.mapstruct.*;

import java.util.List;

@Mapper(componentModel = "spring", uses = { RoleMapper.class, PatenteMapper.class, AbilitaMapper.class })
public interface UserMapper {

    // ========== Request → Entity (Creazione) ==========
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "attivo", constant = "true")
    @Mapping(target = "firstAttempt", constant = "true")
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "roles", ignore = true)
    @Mapping(target = "patenti", ignore = true)
    @Mapping(target = "abilita", ignore = true)
    @Mapping(target = "missioniComeOperatore", ignore = true)
    User toEntity(UserRequest request);

    // ========== UpdateRequest → Entity (Aggiornamento) ==========
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "email", ignore = true)
    @Mapping(target = "password", ignore = true)
    @Mapping(target = "attivo", ignore = true)
    @Mapping(target = "firstAttempt", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "roles", ignore = true)
    @Mapping(target = "patenti", ignore = true)
    @Mapping(target = "abilita", ignore = true)
    @Mapping(target = "missioniComeOperatore", ignore = true)
    void updateEntityFromDto(UserUpdateRequest request, @MappingTarget User user);

    // ========== Entity → Response ==========
    @Mapping(target = "token", ignore = true)
    @Mapping(target = "patenti", source = "patenti")
    @Mapping(target = "abilita", source = "abilita")
    UserResponse toResponse(User user);

    // ========== List mapping ==========
    List<UserResponse> toResponseList(List<User> users);
}
