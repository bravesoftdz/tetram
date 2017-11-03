/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreLiteDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.GenreLite;

import java.util.UUID;

/**
 * Created by Thierry on 10/06/2014.
 */
public interface GenreLiteDao extends DaoRO<GenreLite, UUID>, RepertoireLiteDao<GenreLite, Character> {
}
