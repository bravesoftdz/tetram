/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * PhotoLite.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseImage;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;

/**
 * Created by Thierry on 24/05/2014.
 */
public class PhotoLite extends BaseImage {

    public PhotoLite() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        setCategorie(valeurListeDao.getDefaultTypePhoto());
    }

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return PhotoLite.class;
    }

}
