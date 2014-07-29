/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * DaoScript.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;

/**
 * Created by Thierry on 12/06/2014.
 */
public interface DaoScript<T extends ScriptEntity> {
    void fillAssociations(@NotNull T entity);

    void saveAssociations(@NotNull T entity);
}
