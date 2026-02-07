package it.univaq.webengineering.soccorsoweb.mapper;

import it.univaq.webengineering.soccorsoweb.model.dto.request.RichiestaSoccorsoRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.RichiestaSoccorsoResponse;
import it.univaq.webengineering.soccorsoweb.model.entity.RichiestaSoccorso;
import org.mapstruct.*;

import javax.sql.rowset.serial.SerialBlob;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.List;

@Mapper(componentModel = "spring")
public interface RichiestaSoccorsoMapper {

    // ========== Request → Entity ==========
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "tokenConvalida", ignore = true)
    @Mapping(target = "stato", constant = "ATTIVA")
    @Mapping(target = "ipOrigine", ignore = true)
    @Mapping(target = "convalidataAt", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "missione", ignore = true)
    @Mapping(target = "foto", source = "foto", qualifiedByName = "bytesToBlob")
    RichiestaSoccorso toEntity(RichiestaSoccorsoRequest request);

    // ========== Entity → Response ==========
    @Mapping(target = "missioneId", source = "missione.id")
    @Mapping(target = "foto", source = "foto", qualifiedByName = "blobToBytes")
    RichiestaSoccorsoResponse toResponse(RichiestaSoccorso entity);

    // ========== List mapping ==========
    List<RichiestaSoccorsoResponse> toResponseList(List<RichiestaSoccorso> entities);

    // ========== Conversione byte[] -> Blob ==========
    @Named("bytesToBlob")
    default Blob bytesToBlob(byte[] bytes) {
        if (bytes == null || bytes.length == 0) {
            return null;
        }
        try {
            return new SerialBlob(bytes);
        } catch (SQLException e) {
            throw new RuntimeException("Errore conversione byte[] -> Blob", e);
        }
    }

    // ========== Conversione Blob -> byte[] ==========
    @Named("blobToBytes")
    default byte[] blobToBytes(Blob blob) {
        if (blob == null) {
            return null;
        }
        try {
            return blob.getBytes(1, (int) blob.length());
        } catch (SQLException e) {
            throw new RuntimeException("Errore conversione Blob -> byte[]", e);
        }
    }
}
