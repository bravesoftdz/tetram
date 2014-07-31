/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SerieMapper.java
 * Last modified by Tetram, on 2014-07-31T14:20:44CEST
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

    List<SerieLite> getListSerieIdByAuteurId(@Param("id") UUID id);

    int changeNotation(@Param("id") UUID id, @Param("notation") ValeurListe note);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<SerieLite> getSerieLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    // TODO
    List<InitialeWithEntity<Character, SerieLite>> searchSerieLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}
