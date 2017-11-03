/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EditionDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Edition;

import java.util.UUID;

/**
 * Created by Thierry on 10/06/2014.
 */
public interface EditionDao extends DaoRW<Edition, UUID> {
    void validateFromAlbum(@NotNull Edition edition) throws ConsistencyException;

    void fusionneInto(@NotNull Edition source, @NotNull Edition dest);
}
