package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
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

    Personne getPersonneById(UUID id);

    int createAuteur(Personne personne);

    int updateAuteur(Personne personne);

    int deleteAuteur(UUID id);

    int cleanAuteursSerie(@Param("id") UUID idSerie);

    int addAuteurSerie(@Param("idSerie") UUID idSerie, @Param("auteur") AuteurSerieLite auteur);
}