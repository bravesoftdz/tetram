/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreDaoImpl.java
 * Last modified by Thierry, on 2014-08-06T12:24:33CEST
 */

package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Genre;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
@Transactional
class GenreDaoImpl extends DaoScriptImpl<Genre, UUID> implements GenreDao {

    @Override
    public void validate(@NotNull Genre object) throws ConsistencyException {
        super.validate(object);
        if (StringUtils.isNullOrEmpty(object.getNomGenre()))
            throw new ConsistencyException(I18nSupport.message("nom.obligatoire"));
    }

    @Override
    public int save(@NotNull Genre o) throws ConsistencyException {
        if (!isUnique(o))
            throw new ConsistencyException(I18nSupport.message("title.still.used", I18nSupport.message("genre/one")));
        return super.save(o);
    }

}
