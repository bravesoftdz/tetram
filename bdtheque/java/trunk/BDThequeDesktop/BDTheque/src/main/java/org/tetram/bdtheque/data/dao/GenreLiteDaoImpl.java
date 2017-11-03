/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreLiteDaoImpl.java
 * Last modified by Tetram, on 2014-08-01T10:37:27CEST
 */

package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.dao.mappers.GenreMapper;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
@Transactional
class GenreLiteDaoImpl extends DaoROImpl<GenreLite, UUID> implements GenreLiteDao {

    @Autowired
    private GenreMapper genreMapper;

    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        return genreMapper.getInitiales(filtre);
    }

    @Override
    public List<GenreLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        return genreMapper.getListGenreLiteByInitiale(initiale.getValue(), filtre);
    }

    @Override
    public List<InitialeWithEntity<Character, GenreLite>> searchList(String value, String filtre) {
        return genreMapper.searchListGenreLiteByInitiale(value, filtre);
    }

}
