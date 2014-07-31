/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AuteurMapper.java
 * Last modified by Tetram, on 2014-07-31T14:22:53CEST
 */
package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.*;
import org.tetram.bdtheque.utils.FileLink;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/AuteurMapper.xml")
public interface AuteurMapper extends BaseMapperInterface {
    PersonneLite getPersonneLiteById(@Param("id") UUID id);

    List<AuteurAlbumLite> getListAuteurLiteByAlbumId(@Param("idAlbum") UUID idAlbum);

    List<AuteurSerieLite> getListAuteurLiteBySerieId(@Param("idSerie") UUID idSerie);

    List<AuteurParaBDLite> getListAuteurLiteByParaBDId(@Param("idParaBD") UUID idParaBD);

    Personne getPersonneById(@Param("id") UUID id);

    int cleanAuteursAlbum(@Param("id") UUID idAlbum);

    int addAuteurAlbum(@Param("idAlbum") UUID idAlbum, @Param("auteur") AuteurAlbumLite auteur);

    int cleanAuteursSerie(@Param("id") UUID idSerie);

    int addAuteurSerie(@Param("idSerie") UUID idSerie, @Param("auteur") AuteurSerieLite auteur);

    int cleanAuteursParaBD(@Param("id") UUID idParaBD);

    int addAuteurParaBD(@Param("idParaBD") UUID idParaBD, @Param("auteur") AuteurParaBDLite auteur);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<PersonneLite> getPersonneLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    // TODO
    List<InitialeWithEntity<Character, PersonneLite>> searchPersonneLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}