/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SerieMapper.java
 * Last modified by Tetram, on 2014-08-01T12:28:08CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.*;
import org.tetram.bdtheque.utils.FileLink;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/SerieMapper.xml")
public interface SerieMapper extends BaseMapperInterface {
    SerieLite getSerieLiteById(@Param("id") UUID id);

    Serie getSerieById(@Param("id") UUID id);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int createSerie(Serie serie);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int updateSerie(Serie serie);

    /**
     * utiliser le dao correspondant
     */
    int deleteSerie(UUID id);

    List<SerieLite> getListSerieIdByAuteur(@Param("id") UUID idPersonne);

    int changeNotation(@Param("id") UUID id, @Param("notation") ValeurListe note);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<SerieLite> getListSerieLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    List<InitialeWithEntity<Character, SerieLite>> searchListSerieLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}
