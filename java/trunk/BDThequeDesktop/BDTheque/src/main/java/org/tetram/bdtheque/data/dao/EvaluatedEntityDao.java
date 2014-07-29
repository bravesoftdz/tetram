/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EvaluatedEntityDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.interfaces.EvaluatedEntity;

/**
 * Created by Thierry on 08/07/2014.
 */
public interface EvaluatedEntityDao<T extends EvaluatedEntity> {
    void changeNotation(T entity, ValeurListe notation);
}
