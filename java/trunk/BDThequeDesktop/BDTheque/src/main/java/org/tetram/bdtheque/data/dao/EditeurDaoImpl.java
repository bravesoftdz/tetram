/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EditeurDaoImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
@Transactional
class EditeurDaoImpl extends DaoScriptImpl<Editeur, UUID> implements EditeurDao {
    @Override
    public void validate(@NotNull Editeur object) throws ConsistencyException {
        super.validate(object);
        if (StringUtils.isNullOrEmpty(object.getNomEditeur()))
            throw new ConsistencyException(I18nSupport.message("nom.obligatoire"));
    }

    @Override
    public int save(@NotNull Editeur o) throws ConsistencyException {
        if (!isUnique(o))
            throw new ConsistencyException(I18nSupport.message("title.still.used", I18nSupport.message("editeur")));
        return super.save(o);
    }

}
