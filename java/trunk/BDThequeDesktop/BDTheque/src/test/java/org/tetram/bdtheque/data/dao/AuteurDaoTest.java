package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.Auteur;
import org.tetram.bdtheque.utils.StringUtils;

public class AuteurDaoTest extends DBTest {

    @Autowired
    private AuteurDao dao;

    @Test
    public void testGet() throws Exception {
        Auteur auteur = dao.get(Constants.ID_AUTEUR_BUCHET);
        Assert.assertNotNull(auteur);
        Assert.assertEquals(Constants.ID_AUTEUR_BUCHET, auteur.getId());
        Assert.assertNotNull(auteur.getSeries());
        Assert.assertFalse(auteur.getSeries().isEmpty());
    }

    @Test
    public void testCreate() throws Exception {
        int rowCount;

        Auteur auteur;

        auteur = new Auteur();
        auteur.setNomAuteur(Constants.TEST_CREATE);

        rowCount = dao.save(auteur);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(auteur.getId());
        Assert.assertNotEquals(StringUtils.GUID_NULL, auteur.getId());

        auteur = dao.get(auteur.getId());
        Assert.assertEquals(Constants.TEST_CREATE, auteur.getNomAuteur());

        auteur.setNomAuteur(Constants.TEST_UPDATE);
        rowCount = dao.save(auteur);
        Assert.assertEquals(1, rowCount);

        auteur = dao.get(auteur.getId());
        Assert.assertEquals(Constants.TEST_UPDATE, auteur.getNomAuteur());

        rowCount = dao.delete(auteur.getId());
        Assert.assertEquals(1, rowCount);

        auteur = dao.get(auteur.getId());
        Assert.assertNull(auteur);
    }

    @Test(expected = ConsistencyException.class)
    public void testCreateIsUnique() throws Exception {
        @NonNls Auteur auteur = new Auteur();
        auteur.setNomAuteur(Constants.NOM_AUTEUR_BUCHET);

        dao.save(auteur);
        Assert.fail();
    }

    @Test(expected = ConsistencyException.class)
    public void testUpdateIsUnique() throws Exception {
        @NonNls Auteur auteur = new Auteur();
        auteur.setNomAuteur(Constants.NOM_AUTEUR_BUCHET);
        auteur.setId(StringUtils.GUID_FULL);

        dao.save(auteur);
        Assert.fail();
    }
}