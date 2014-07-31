/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AlbumLiteGenreDaoImpl.java
 * Last modified by Tetram, on 2014-07-31T11:52:45CEST
 */

package org.tetram.bdtheque.data.dao;

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
public class AlbumLiteGenreDaoImpl extends DaoROImpl<AlbumLite, UUID> implements AlbumLiteGenreDao {

    private static final String UNKNOWN_LABEL = I18nSupport.message("initiale.inconnu.genre");
    @Autowired
    private AlbumMapper albumMapper;

    @Override
    public List<InitialeEntity<UUID>> getListInitiales(String filtre) {
        return albumMapper.getInitialesGenres(filtre);
    }

    @Override
    public String getUnknownLabel() {
        return UNKNOWN_LABEL;
    }

    @Override
    public List<AlbumLite> getListEntitiesByInitiale(InitialeEntity<UUID> initiale, String filtre) {
        return albumMapper.getAlbumLiteByGenre(initiale.getValue(), filtre);
    }

    @Override
    public List<InitialeWithEntity<UUID, AlbumLite>> searchList(String value, String filtre) {
        return albumMapper.searchAlbumLiteByGenre(value, filtre);
    }

}
