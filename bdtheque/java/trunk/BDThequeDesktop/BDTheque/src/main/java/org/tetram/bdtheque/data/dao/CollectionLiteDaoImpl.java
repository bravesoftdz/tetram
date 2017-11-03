/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * CollectionLiteDaoImpl.java
 * Last modified by Tetram, on 2014-08-01T10:07:11CEST
 */

package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.CollectionLite;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.dao.mappers.CollectionMapper;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 17/07/2014.
 */
@Repository
@Lazy
@Transactional
class CollectionLiteDaoImpl extends DaoROImpl<CollectionLite, UUID> implements CollectionLiteDao {

    @Autowired
    private CollectionMapper collectionMapper;

    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        return collectionMapper.getInitiales(filtre);
    }

    @Override
    public List<CollectionLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        return collectionMapper.getListCollectionLiteByInitiale(initiale.getValue(), filtre);
    }

    @Override
    public List<InitialeWithEntity<Character, CollectionLite>> searchList(String value, String filtre) {
        return collectionMapper.searchListCollectionLiteByInitiale(value, filtre);
    }

}
