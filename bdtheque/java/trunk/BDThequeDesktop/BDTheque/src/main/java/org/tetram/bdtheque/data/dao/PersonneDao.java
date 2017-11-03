/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * PersonneDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.Personne;

import java.util.UUID;

/**
 * Created by Thierry on 10/06/2014.
 */
@Transactional(propagation = Propagation.REQUIRED)
public interface PersonneDao extends DaoRW<Personne, UUID> {

}
