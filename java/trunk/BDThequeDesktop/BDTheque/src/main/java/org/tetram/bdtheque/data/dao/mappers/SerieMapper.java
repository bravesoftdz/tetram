/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SerieMapper.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.SerieLite;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.utils.FileLink;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/Serie.xml")
public interface SerieMapper extends BaseMapperInterface {
    SerieLite getSerieLiteById(@Param("id") UUID id);

    Serie getSerieById(UUID id);

    List<SerieLite> getListSerieIdByAuteurId(UUID id);

    int changeNotation(@Param("id") UUID id, @Param("notation") ValeurListe note);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<SerieLite> getSerieLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);
}
