/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ParaBDLiteDaoImpl.java
 * Last modified by Tetram, on 2014-08-01T11:41:33CEST
 */

package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.bean.ParaBDLite;
import org.tetram.bdtheque.data.dao.mappers.ParaBDMapper;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 27/06/2014.
 */
@Repository
@Lazy
@Transactional
public class ParaBDLiteDaoImpl extends DaoROImpl<ParaBDLite, UUID> implements ParaBDLiteDao {

    @Autowired
    private ParaBDMapper paraBDMapper;

    @Override
    public List<InitialeEntity<UUID>> getListInitiales(String filtre) {
        return paraBDMapper.getInitialesSeries(filtre);
    }

    @Override
    public List<ParaBDLite> getListEntitiesByInitiale(InitialeEntity<UUID> initiale, String filtre) {
        return paraBDMapper.getListParaBDLiteBySerie(initiale.getValue(), filtre);
    }

    @Override
    public List<InitialeWithEntity<UUID, ParaBDLite>> searchList(String value, String filtre) {
        return paraBDMapper.searchListParaBDLiteBySerie(value, filtre);
    }

}
