/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AuteurMapper.java
 * Last modified by Tetram, on 2014-08-01T12:22:38CEST
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

    List<AuteurAlbumLite> getListAuteurLiteByAlbum(@Param("idAlbum") UUID idAlbum);

    List<AuteurSerieLite> getListAuteurLiteBySerie(@Param("idSerie") UUID idSerie);

    List<AuteurParaBDLite> getListAuteurLiteByParaBD(@Param("idParaBD") UUID idParaBD);

    Personne getPersonneById(@Param("id") UUID id);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    UUID checkUniquePersonne(Personne personne);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int createPersonne(Personne personne);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int updatePersonne(Personne personne);

    /**
     * utiliser le dao correspondant
     */
    int deletePersonne(UUID id);

    int cleanAuteursAlbum(@Param("id") UUID idAlbum);

    int addAuteurAlbum(@Param("idAlbum") UUID idAlbum, @Param("auteur/one") AuteurAlbumLite auteur);

    int cleanAuteursSerie(@Param("id") UUID idSerie);

    int addAuteurSerie(@Param("idSerie") UUID idSerie, @Param("auteur/one") AuteurSerieLite auteur);

    int cleanAuteursParaBD(@Param("id") UUID idParaBD);

    int addAuteurParaBD(@Param("idParaBD") UUID idParaBD, @Param("auteur/one") AuteurParaBDLite auteur);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<PersonneLite> getListPersonneLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    List<InitialeWithEntity<Character, PersonneLite>> searchListPersonneLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}