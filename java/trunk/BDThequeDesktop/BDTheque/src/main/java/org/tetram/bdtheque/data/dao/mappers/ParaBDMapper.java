/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ParaBDMapper.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.ParaBD;
import org.tetram.bdtheque.data.bean.ParaBDLite;
import org.tetram.bdtheque.utils.FileLink;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/ParaBD.xml")
public interface ParaBDMapper extends BaseMapperInterface {
    ParaBDLite getParaBDLiteById(UUID id);

    ParaBD getParaBDById(UUID id);

    List<ParaBDLite> getListParaBDLiteBySerieIdByAuteurId(@Param("idSerie") UUID idSerie, @Param("idAuteur") UUID idAuteur);

    int acheter(@Param("id") UUID id, @Param("achat") boolean previsionAchat);

    List<InitialeEntity<UUID>> getInitiales(@Param("filtre") String filtre);

    List<ParaBDLite> getListParaBDLiteBySerieId(@Param("idSerie") UUID idSerie, @Param("filtre") String filtre);

    List<InitialeEntity<UUID>> getInitialesSeries(@Param("filtre") String filtre);
}
