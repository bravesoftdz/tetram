/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * CollectionDaoTest.java
 * Last modified by Tetram, on 2014-07-29T11:02:08CEST
 */

package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.dao.mappers.SqlMapper;
import org.tetram.bdtheque.utils.TypeUtils;

public class CollectionDaoTest extends SpringTest {

    @Autowired
    private CollectionDao dao;
    @Autowired
    private EditeurDao daoEditeur;
    @Autowired
    private SqlMapper sqlMapper;

    @Before
    public void setUp() {
        sqlMapper.execute("delete from collections where nomcollection = '" + Constants.TEST_CREATE + "'");
    }

    @Test
    public void testGet() throws Exception {
        Collection collection = dao.get(Constants.ID_COLLECTION_NEOPOLIS_DELCOURT);
        Assert.assertNotNull(collection);
        Assert.assertNotNull(collection.getId());
        Assert.assertNotNull(collection.getNomCollection());
    }

    @Test
    public void testCreate() throws Exception {
        int rowCount;

        Collection collection;

        collection = new Collection();
        collection.setNomCollection(Constants.TEST_CREATE);
        collection.setEditeur(daoEditeur.get(Constants.ID_EDITEUR_DELCOURT));

        rowCount = dao.save(collection);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(collection.getId());
        Assert.assertNotEquals(TypeUtils.GUID_NULL, collection.getId());

        Collection oldCollection = collection;
        collection = dao.get(collection.getId());
        Assert.assertEquals(0, oldCollection.fullCompare(collection));
        Assert.assertEquals(Constants.TEST_CREATE, collection.getNomCollection());
        Assert.assertNotNull(collection.getEditeur());
        Assert.assertEquals(Constants.ID_EDITEUR_DELCOURT, collection.getEditeur().getId());

        collection.setNomCollection(Constants.TEST_UPDATE);
        rowCount = dao.save(collection);
        Assert.assertEquals(1, rowCount);

        collection = dao.get(collection.getId());
        Assert.assertEquals(Constants.TEST_UPDATE, collection.getNomCollection());

        rowCount = dao.delete(collection.getId());
        Assert.assertEquals(1, rowCount);

        collection = dao.get(collection.getId());
        Assert.assertNull(collection);
    }

    @Test(expected = ConsistencyException.class)
    public void testCreateIsUnique() throws Exception {
        @NonNls Collection collection = new Collection();
        collection.setNomCollection(Constants.NOM_COLLECTION_NÉOPOLIS_DELCOURT);
        collection.setEditeur(daoEditeur.get(Constants.ID_EDITEUR_DELCOURT));

        dao.save(collection);
        Assert.fail();
    }

    @Test(expected = ConsistencyException.class)
    public void testUpdateIsUnique() throws Exception {
        @NonNls Collection collection = new Collection();
        collection.setNomCollection(Constants.NOM_COLLECTION_NÉOPOLIS_DELCOURT);
        collection.setEditeur(daoEditeur.get(Constants.ID_EDITEUR_DELCOURT));
        collection.setId(TypeUtils.GUID_FULL);

        dao.save(collection);
        Assert.fail();
    }

    @Test(expected = ConsistencyException.class)
    public void testValidate() throws Exception {
        @NonNls Collection collection = new Collection();
        collection.setNomCollection(Constants.NOM_COLLECTION_NÉOPOLIS_DELCOURT);
        collection.setId(TypeUtils.GUID_FULL);

        dao.validate(collection);
        Assert.fail();
    }

}