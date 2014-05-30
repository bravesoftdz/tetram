package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.Auteur;

public class AuteurDaoTest extends DBTest {

    private AuteurDao dao;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        dao = DaoFactory.getInstance().getDao(AuteurDao.class);
    }

    @Test
    public void testGet() throws Exception {
        Auteur auteur = dao.get(ID_AUTEUR_BUCHET);
        Assert.assertNotNull(auteur);
        Assert.assertEquals(ID_AUTEUR_BUCHET, auteur.getId());
        Assert.assertNotNull(auteur.getSeries());
        Assert.assertFalse(auteur.getSeries().isEmpty());
    }
}