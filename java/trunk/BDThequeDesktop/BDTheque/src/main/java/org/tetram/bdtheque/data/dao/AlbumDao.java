/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AlbumDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.bean.Album;

import java.util.UUID;

/**
 * Created by Thierry on 10/06/2014.
 */
public interface AlbumDao extends DaoRW<Album, UUID> {
    void fusionneInto(@NotNull Album source, @NotNull Album dest);
}
