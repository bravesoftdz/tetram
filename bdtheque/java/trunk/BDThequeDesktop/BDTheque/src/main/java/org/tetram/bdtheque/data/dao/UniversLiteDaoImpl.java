/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * UniversLiteDaoImpl.java
 * Last modified by Tetram, on 2014-08-01T10:42:50CEST
 */

package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.dao.mappers.UniversMapper;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 12/06/2014.
 */
@Repository
@Lazy
@Transactional
class UniversLiteDaoImpl extends DaoROImpl<UniversLite, UUID> implements UniversLiteDao {

    @Autowired
    private UniversMapper universMapper;

    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        return universMapper.getInitiales(filtre);
    }

    @Override
    public List<UniversLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        return universMapper.getListUniversLiteByInitiale(initiale.getValue(), filtre);
    }

    @Override
    public List<InitialeWithEntity<Character, UniversLite>> searchList(String value, String filtre) {
        return universMapper.searchListUniversLiteByInitiale(value, filtre);
    }

}
