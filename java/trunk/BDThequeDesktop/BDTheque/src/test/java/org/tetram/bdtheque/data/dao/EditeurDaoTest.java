package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.utils.StringUtils;

public class EditeurDaoTest extends DBTest {

    EditeurDao dao = Database.getInstance().getApplicationContext().getBean(EditeurDao.class);

    @Test
    public void testGet() throws Exception {
        Editeur editeur = dao.get(Constants.ID_EDITEUR_GLENAT);
        Assert.assertNotNull(editeur);
        Assert.assertNotNull(editeur.getId());
        Assert.assertNotNull(editeur.getNomEditeur());
    }

    @Test
    public void testCreate() throws Exception {
        int rowCount;

        Editeur editeur;

        editeur = new Editeur();
        editeur.setNomEditeur(Constants.TEST_CREATE);

        rowCount = dao.save(editeur);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(editeur.getId());
        Assert.assertNotEquals(StringUtils.GUID_NULL, editeur.getId());

        editeur = dao.get(editeur.getId());
        Assert.assertEquals(Constants.TEST_CREATE, editeur.getNomEditeur());

        editeur.setNomEditeur(Constants.TEST_UPDATE);
        rowCount = dao.save(editeur);
        Assert.assertEquals(1, rowCount);

        editeur = dao.get(editeur.getId());
        Assert.assertEquals(Constants.TEST_UPDATE, editeur.getNomEditeur());

        rowCount = dao.delete(editeur.getId());
        Assert.assertEquals(1, rowCount);

        editeur = dao.get(editeur.getId());
        Assert.assertNull(editeur);
    }

    @Test(expected = ConsistencyException.class)
    public void testCreateIsUnique() throws Exception {
        @NonNls Editeur editeur = new Editeur();
        editeur.setNomEditeur(Constants.NOM_EDITEUR_GLÉNAT);

        dao.save(editeur);
        Assert.fail();
    }

    @Test(expected = ConsistencyException.class)
    public void testUpdateIsUnique() throws Exception {
        @NonNls Editeur editeur = new Editeur();
        editeur.setNomEditeur(Constants.NOM_EDITEUR_GLÉNAT);
        editeur.setId(StringUtils.GUID_FULL);

        dao.save(editeur);
        Assert.fail();
    }

}