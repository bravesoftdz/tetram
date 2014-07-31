/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ParaBDMapper.java
 * Last modified by Tetram, on 2014-07-31T14:24:11CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.bean.ParaBD;
import org.tetram.bdtheque.data.bean.ParaBDLite;
import org.tetram.bdtheque.utils.FileLink;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/ParaBDMapper.xml")
public interface ParaBDMapper extends BaseMapperInterface {
    ParaBDLite getParaBDLiteById(@Param("id") UUID id);

    ParaBD getParaBDById(@Param("id") UUID id);

    List<ParaBDLite> getListParaBDLiteBySerieIdByAuteurId(@Param("idSerie") UUID idSerie, @Param("idAuteur") UUID idAuteur);

    int acheter(@Param("id") UUID id, @Param("achat") boolean previsionAchat);

    List<ParaBDLite> getListParaBDLiteBySerieId(@Param("idSerie") UUID idSerie, @Param("filtre") String filtre);

    List<InitialeEntity<UUID>> getInitialesSeries(@Param("filtre") String filtre);

    // TODO
    List<InitialeWithEntity<UUID, ParaBDLite>> searchParaBDLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}
