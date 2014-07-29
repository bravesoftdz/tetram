/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * PersonneLiteDaoImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.bean.PersonneLite;
import org.tetram.bdtheque.data.dao.mappers.AuteurMapper;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 13/06/2014.
 */
@Repository
@Lazy
@Transactional

public class PersonneLiteDaoImpl extends DaoROImpl<PersonneLite, UUID> implements PersonneLiteDao {

    @Autowired
    private AuteurMapper auteurMapper;

    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        return auteurMapper.getInitiales(filtre);
    }

    @Override
    public List<PersonneLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        return auteurMapper.getPersonneLiteByInitiale(initiale.getValue(), filtre);
    }

    @Override
    public List<InitialeWithEntity<Character, PersonneLite>> searchList(@Param("value") String value, @Param("filtre") String filtre) {
        // TODO
        return null;
    }

}
