package org.tetram.bdtheque.data.mappers;

import org.tetram.bdtheque.data.bean.*;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
public interface AuteurMapper {
    PersonneLite getPersonneLiteById(UUID id);

    List<AuteurAlbumLite> getListAuteurLiteByAlbumId(UUID id);

    List<AuteurSerieLite> getListAuteurLiteBySerieId(UUID id);

    List<AuteurParaBDLite> getListAuteurLiteByParaBDId(UUID id);

    Auteur getAuteurById(UUID id);
}