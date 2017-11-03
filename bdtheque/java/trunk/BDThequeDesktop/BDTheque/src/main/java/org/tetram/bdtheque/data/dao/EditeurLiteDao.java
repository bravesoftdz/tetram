/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EditeurLiteDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.EditeurLite;

import java.util.UUID;

/**
 * Created by Thierry on 11/06/2014.
 */
public interface EditeurLiteDao extends DaoRO<EditeurLite, UUID>, RepertoireLiteDao<EditeurLite, Character> {
}
