package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Test;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.Auteur;

public class AuteurMapperTest extends DBTest {

    private AuteurMapper mapper = Database.getInstance().getApplicationContext().getBean(AuteurMapper.class);

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
        Auteur auteur = mapper.getAuteurById(Constants.ID_AUTEUR_BUCHET);
        Assert.assertNotNull(auteur);
        Assert.assertEquals(Constants.ID_AUTEUR_BUCHET, auteur.getId());
        Assert.assertNotNull(auteur.getSeries());
        Assert.assertTrue(auteur.getSeries().isEmpty());
    }
}