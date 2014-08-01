/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ParaBDMapper.java
 * Last modified by Tetram, on 2014-08-01T12:28:08CEST
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

    /**
     * ne surtout pas mettre @Param
     *
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    int createParaBD(ParaBD parabd);

    /**
     * ne surtout pas mettre @Param
     *
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    int updateParaBD(ParaBD parabd);

    /**
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    int deleteParaBD(UUID id);


    List<ParaBDLite> getListParaBDLiteBySerieByAuteur(@Param("idSerie") UUID idSerie, @Param("idAuteur") UUID idAuteur);

    int acheter(@Param("id") UUID id, @Param("achat") boolean previsionAchat);

    List<ParaBDLite> getListParaBDLiteBySerie(@Param("idSerie") UUID idSerie, @Param("filtre") String filtre);

    List<InitialeEntity<UUID>> getInitialesSeries(@Param("filtre") String filtre);

    List<InitialeWithEntity<UUID, ParaBDLite>> searchListParaBDLiteBySerie(@Param("value") String value, @Param("filtre") String filtre);
}
