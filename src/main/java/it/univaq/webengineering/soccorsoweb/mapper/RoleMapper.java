package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.RoleRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.RoleResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.Role;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring")
public interface RoleMapper {

    // ========== Request → Entity ==========
    @Mapping(target = "id", ignore = true)
    Role toEntity(RoleRequest request);

    // ========== Entity → Response ==========
    RoleResponse toResponse(Role role);

    // ========== List/Set mapping ==========
    List<RoleResponse> toResponseList(List<Role> roles);

    Set<RoleResponse> toResponseSet(Set<Role> roles);
}
