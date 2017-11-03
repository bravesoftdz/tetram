/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * CollectionMapperTest.java
 * Last modified by Tetram, on 2014-08-01T12:24:45CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.bean.CollectionLite;

import java.util.List;

public class CollectionMapperTest extends SpringTest {

    @Autowired
    private CollectionMapper mapper;

    @Test
    public void testGetCollectionLiteById() throws Exception {
        CollectionLite collectionLite = mapper.getCollectionLiteById(Constants.ID_COLLECTION_GENERATION_COMICS_PANINI);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(collectionLite);
        Assert.assertEquals(Constants.ID_COLLECTION_GENERATION_COMICS_PANINI, collectionLite.getId());
    }

    @Test
    public void testGetListCollectionLiteByEditeurId() throws Exception {
        List<CollectionLite> lstCollectionLite = mapper.getListCollectionLiteByEditeur(Constants.ID_EDITEUR_GLENAT);
        Assert.assertFalse(lstCollectionLite.isEmpty());
        Assert.assertNotNull(lstCollectionLite.get(0).getId());
    }

    @Test
    public void testGetCollectionById() throws Exception {
        Collection collection = mapper.getCollectionById(Constants.ID_COLLECTION_GENERATION_COMICS_PANINI);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(collection);
        Assert.assertEquals(Constants.ID_COLLECTION_GENERATION_COMICS_PANINI, collection.getId());
    }
}