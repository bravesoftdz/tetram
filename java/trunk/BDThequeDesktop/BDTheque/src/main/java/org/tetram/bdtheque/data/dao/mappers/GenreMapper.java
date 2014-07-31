/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreMapper.java
 * Last modified by Tetram, on 2014-07-31T14:33:19CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
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

    List<GenreLite> getListGenreBySerieId(@Param("id") UUID id);

    int createGenreLite(@Param("genre") GenreLite genre);

    int updateGenreLite(@Param("genre") GenreLite genre);

    int deleteGenreLite(@Param("id") UUID id);

    int cleanGenresSerie(@Param("id") UUID idSerie);

    int addGenreSerie(@Param("idSerie") UUID idSerie, @Param("idGenre") UUID idGenre);

    // TODO
    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    // TODO
    List<GenreLite> getListGenreLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    // TODO
    List<InitialeWithEntity<Character, GenreLite>> searchGenreLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}


