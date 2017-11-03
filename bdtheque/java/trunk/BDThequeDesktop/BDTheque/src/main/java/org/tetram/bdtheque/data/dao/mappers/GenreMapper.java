/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreMapper.java
 * Last modified by Tetram, on 2014-08-01T12:37:04CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.Genre;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.utils.FileLink;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 02/06/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/GenreMapper.xml")
public interface GenreMapper extends BaseMapperInterface {
    GenreLite getGenreLiteById(@Param("id") UUID id);

    Genre getGenreById(@Param("id") UUID id);

    List<GenreLite> getListGenreBySerie(@Param("id") UUID idSerie);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    UUID checkUniqueGenre(Genre genre);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int createGenre(Genre genre);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int updateGenre(Genre genre);

    /**
     * utiliser le dao correspondant
     */
    int deleteGenre(@Param("id") UUID id);

    int cleanGenresSerie(@Param("id") UUID idSerie);

    int addGenreSerie(@Param("idSerie") UUID idSerie, @Param("idGenre") UUID idGenre);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<GenreLite> getListGenreLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    List<InitialeWithEntity<Character, GenreLite>> searchListGenreLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}


