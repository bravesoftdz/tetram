/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ParaBDLiteDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.ParaBDLite;

import java.util.UUID;

/**
 * Created by Thierry on 27/06/2014.
 */
public interface ParaBDLiteDao extends DaoRO<ParaBDLite, UUID>, RepertoireLiteDao<ParaBDLite, UUID> {
}
