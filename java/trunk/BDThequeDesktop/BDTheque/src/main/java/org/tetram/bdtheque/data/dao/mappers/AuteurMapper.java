package org.tetram.bdtheque.data.dao.mappers;

import org.tetram.bdtheque.data.bean.*;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
public interface AuteurMapper extends BaseMapperInterface {
    PersonneLite getPersonneLiteById(UUID id);

    List<AuteurAlbumLite> getListAuteurLiteByAlbumId(UUID id);

    List<AuteurSerieLite> getListAuteurLiteBySerieId(UUID id);

    List<AuteurParaBDLite> getListAuteurLiteByParaBDId(UUID id);

    Auteur getAuteurById(UUID id);

    int createAuteur(Auteur auteur);

    int updateAuteur(Auteur auteur);

    int deleteAuteur(UUID id);
}