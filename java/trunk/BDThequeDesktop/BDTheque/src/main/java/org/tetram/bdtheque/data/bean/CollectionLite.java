/*
 * Copyright (c) 2015, tetram.org. All Rights Reserved.
 * CollectionLite.java
 * Last modified by Thierry, on 2014-10-30T19:14:27CET
 */

package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.abstractentities.BaseCollection;
import org.tetram.bdtheque.data.dao.EditeurLiteDao;
import org.tetram.bdtheque.spring.SpringContext;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */

public class CollectionLite extends BaseCollection<EditeurLite> {

    public void setIdEditeur(UUID idEditeur){
        EditeurLiteDao editeurLiteDao = SpringContext.CONTEXT.getBean(EditeurLiteDao.class);
        setEditeur(editeurLiteDao.get(idEditeur));
    }

}
