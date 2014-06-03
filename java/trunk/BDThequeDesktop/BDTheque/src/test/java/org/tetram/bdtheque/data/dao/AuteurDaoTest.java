package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Test;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.Auteur;

public class AuteurDaoTest extends DBTest {

    private AuteurDao dao = Database.getInstance().getApplicationContext().getBean(AuteurDao.class);

    @Test
    public void testGet() throws Exception {
        Auteur auteur = dao.get(Constants.ID_AUTEUR_BUCHET);
        Assert.assertNotNull(auteur);
        Assert.assertEquals(Constants.ID_AUTEUR_BUCHET, auteur.getId());
        Assert.assertNotNull(auteur.getSeries());
        Assert.assertFalse(auteur.getSeries().isEmpty());
    }
}