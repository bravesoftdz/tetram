/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * PersonneDaoTest.java
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
import org.tetram.bdtheque.data.bean.Personne;
import org.tetram.bdtheque.data.dao.mappers.SqlMapper;
import org.tetram.bdtheque.utils.TypeUtils;

public class PersonneDaoTest extends SpringTest {

    @Autowired
    private PersonneDao dao;
    @Autowired
    private SqlMapper sqlMapper;

    @SuppressWarnings("HardCodedStringLiteral")
    @Before
    public void setUp() {
        sqlMapper.execute("delete from personnes where nompersonne = '" + Constants.TEST_CREATE + "'");
    }

    @Test
    public void testGet() throws Exception {
        Personne personne = dao.get(Constants.ID_AUTEUR_BUCHET);
        Assert.assertNotNull(personne);
        Assert.assertEquals(Constants.ID_AUTEUR_BUCHET, personne.getId());
        Assert.assertNotNull(personne.getSeries());
        Assert.assertFalse(personne.getSeries().isEmpty());
    }

    @Test
    public void testCreate() throws Exception {
        int rowCount;

        Personne personne;

        personne = new Personne();
        personne.setNomPersonne(Constants.TEST_CREATE);

        rowCount = dao.save(personne);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(personne.getId());
        Assert.assertNotEquals(TypeUtils.GUID_NULL, personne.getId());

        personne = dao.get(personne.getId());
        Assert.assertEquals(Constants.TEST_CREATE, personne.getNomPersonne());

        personne.setNomPersonne(Constants.TEST_UPDATE);
        rowCount = dao.save(personne);
        Assert.assertEquals(1, rowCount);

        personne = dao.get(personne.getId());
        Assert.assertEquals(Constants.TEST_UPDATE, personne.getNomPersonne());

        rowCount = dao.delete(personne.getId());
        Assert.assertEquals(1, rowCount);

        personne = dao.get(personne.getId());
        Assert.assertNull(personne);
    }

    @Test(expected = ConsistencyException.class)
    public void testCreateIsUnique() throws Exception {
        @NonNls Personne personne = new Personne();
        personne.setNomPersonne(Constants.NOM_AUTEUR_BUCHET);

        dao.save(personne);
        Assert.fail();
    }

    @Test(expected = ConsistencyException.class)
    public void testUpdateIsUnique() throws Exception {
        @NonNls Personne personne = new Personne();
        personne.setNomPersonne(Constants.NOM_AUTEUR_BUCHET);
        personne.setId(TypeUtils.GUID_FULL);

        dao.save(personne);
        Assert.fail();
    }
}