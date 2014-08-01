/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EditeurLiteDaoImpl.java
 * Last modified by Tetram, on 2014-08-01T10:30:19CEST
 */

package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.EditeurLite;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.dao.mappers.EditeurMapper;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 11/06/2014.
 */
@Repository
@Lazy
@Transactional
public class EditeurLiteDaoImpl extends DaoROImpl<EditeurLite, UUID> implements EditeurLiteDao {
    @Autowired
    private EditeurMapper editeurMapper;

    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        return editeurMapper.getInitiales(filtre);
    }

    @Override
    public List<EditeurLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        return editeurMapper.getListEditeurLiteByInitiale(initiale.getValue(), filtre);
    }

    @Override
    public List<InitialeWithEntity<Character, EditeurLite>> searchList(String value, String filtre) {
        return editeurMapper.searchListEditeurLiteByInitiale(value, filtre);
    }


}
