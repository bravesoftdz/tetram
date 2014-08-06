/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * CollectionDaoImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
@Transactional
class CollectionDaoImpl extends DaoScriptImpl<Collection, UUID> implements CollectionDao {

    @Override
    public void validate(@NotNull Collection object) throws ConsistencyException {
        if (StringUtils.isNullOrEmpty(object.getNomCollection()))
            throw new ConsistencyException(I18nSupport.message("nom.obligatoire"));
        if (object.getEditeur() == null)
            throw new ConsistencyException(I18nSupport.message("editeur.obligatoire"));
    }

    @Override
    public int save(@NotNull Collection o) throws ConsistencyException {
        if (!isUnique(o))
            throw new ConsistencyException(I18nSupport.message("title.still.used", I18nSupport.message("collection")));
        return super.save(o);
    }
}
