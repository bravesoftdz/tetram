package org.tetram.bdtheque.data.mappers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.Auteur;

public class AuteurMapperTest extends DBTest {

    private AuteurMapper mapper;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        mapper = dbSession.getMapper(AuteurMapper.class);
    }

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
        Auteur auteur = mapper.getAuteurById(ID_AUTEUR_BUCHET);
        Assert.assertNotNull(auteur);
        Assert.assertEquals(ID_AUTEUR_BUCHET, auteur.getId());
        Assert.assertNotNull(auteur.getSeries());
        Assert.assertTrue(auteur.getSeries().isEmpty());
    }
}