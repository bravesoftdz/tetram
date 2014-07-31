/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AlbumLiteAnneeDaoImpl.java
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

import java.time.Year;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 23/06/2014.
 */
@Repository
@Lazy
@Transactional
public class AlbumLiteAnneeDaoImpl extends DaoROImpl<AlbumLite, UUID> implements AlbumLiteAnneeDao {

    private static final String UNKNOWN_LABEL = I18nSupport.message("initiale.inconnu.annee");
    @Autowired
    private AlbumMapper albumMapper;

    @Override
    public List<InitialeEntity<Year>> getListInitiales(String filtre) {
        return albumMapper.getInitialesAnnees(filtre);
    }

    @Override
    public String getUnknownLabel() {
        return UNKNOWN_LABEL;
    }

    @Override
    public List<AlbumLite> getListEntitiesByInitiale(InitialeEntity<Year> initiale, String filtre) {
        return albumMapper.getAlbumLiteByAnnee(initiale.getValue(), filtre);
    }

    @Override
    public List<InitialeWithEntity<Year, AlbumLite>> searchList(String value, String filtre) {
        return albumMapper.searchAlbumLiteByAnnee(value, filtre);
    }

}
