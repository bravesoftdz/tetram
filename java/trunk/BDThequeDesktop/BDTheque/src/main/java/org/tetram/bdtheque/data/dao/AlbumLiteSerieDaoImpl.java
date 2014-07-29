/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AlbumLiteSerieDaoImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.dao.mappers.AlbumMapper;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 23/06/2014.
 */
@Repository
@Lazy
@Transactional

public class AlbumLiteSerieDaoImpl extends DaoROImpl<AlbumLite, UUID> implements AlbumLiteSerieDao {

    public static final String UNKNOWN_LABEL = I18nSupport.message("initiale.inconnu.serie");

    @Autowired
    private AlbumMapper albumMapper;

    @SuppressWarnings("unchecked")
    @Override
    public List<InitialeEntity<UUID>> getListInitiales(String filtre) {
        return albumMapper.getInitialesSeries(filtre);
    }

    @Override
    public String getUnknownLabel() {
        return UNKNOWN_LABEL;
    }

    @Override
    public List<AlbumLite> getListEntitiesByInitiale(InitialeEntity<UUID> initiale, String filtre) {
        return albumMapper.getListAlbumLiteBySerie(initiale.getValue(), filtre);
    }

    @Override
    public List<InitialeWithEntity<UUID, AlbumLite>> searchList(@Param("value") String value, @Param("filtre") String filtre) {
        return albumMapper.searchAlbumLiteBySerie(value, filtre);
    }

}
