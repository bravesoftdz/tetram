/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * DaoRO.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;

/**
 * Created by Thierry on 11/06/2014.
 */
public interface DaoRO<T, PK> {
    T get(PK id) throws PersistenceException;//get obj of type T by the primary key 'id'
}
