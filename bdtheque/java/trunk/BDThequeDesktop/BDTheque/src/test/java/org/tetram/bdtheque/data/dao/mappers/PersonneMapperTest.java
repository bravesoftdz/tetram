/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * PersonneMapperTest.java
 * Last modified by Tetram, on 2014-07-29T11:02:08CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.Personne;

public class PersonneMapperTest extends SpringTest {

    @Autowired
    private AuteurMapper mapper;

    @Test
    public void testGetPersonneLiteById() throws Exception {

    }

    @Test
    public void testGetListAuteurLiteByAlbumId() throws Exception {

    }

    @Test
    public void testGetListAuteurLiteBySerieId() throws Exception {

    }

    @Test
    public void testGetListAuteurLiteByParaBDId() throws Exception {

    }

    @Test
    public void testGetAuteurById() throws Exception {
        Personne personne = mapper.getPersonneById(Constants.ID_AUTEUR_BUCHET);
        Assert.assertNotNull(personne);
        Assert.assertEquals(Constants.ID_AUTEUR_BUCHET, personne.getId());
        Assert.assertNotNull(personne.getSeries());
        Assert.assertTrue(personne.getSeries().isEmpty());
    }
}