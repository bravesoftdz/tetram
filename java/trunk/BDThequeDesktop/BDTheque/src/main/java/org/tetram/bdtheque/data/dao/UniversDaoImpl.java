/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * UniversDaoImpl.java
 * Last modified by Tetram, on 2014-08-26T09:36:34CEST
 */

package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
@Transactional
class UniversDaoImpl extends DaoScriptImpl<Univers, UUID> implements UniversDao {
    @Override
    public int save(@NotNull Univers o) throws ConsistencyException {
        if (!isUnique(o))
            throw new ConsistencyException(I18nSupport.message("title.still.used", I18nSupport.message("univers/one")));
        return super.save(o);
    }

    @Override
    public void validate(@NotNull Univers object) throws ConsistencyException {
        super.validate(object);
        if (StringUtils.isNullOrEmpty(object.getNomUnivers()))
            throw new ConsistencyException("nom.obligatoire");
    }
}
