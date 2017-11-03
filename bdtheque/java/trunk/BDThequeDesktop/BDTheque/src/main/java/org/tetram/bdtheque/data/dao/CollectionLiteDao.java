/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * CollectionLiteDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.CollectionLite;

import java.util.UUID;

/**
 * Created by Thierry on 17/07/2014.
 */
public interface CollectionLiteDao extends DaoRO<CollectionLite, UUID>, RepertoireLiteDao<CollectionLite, Character> {
}
