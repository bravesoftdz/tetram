package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.bean.lite.EditeurLite;
import org.tetram.bdtheque.utils.StringUtils;

public class EditeurDaoTest extends DaoTest {

    protected EditeurDao dao;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        dao = dbSession.getMapper(EditeurDao.class);
    }

    @Test
    public void testGetEditeurLiteById() throws Exception {
        EditeurLite editeurLite = dao.getEditeurLiteById(ID_EDITEUR_GLENAT);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeurLite);
        Assert.assertEquals(editeurLite.getId(), ID_EDITEUR_GLENAT);
    }

    @Test
    public void testGetEditeurById() throws Exception {
        Editeur editeur = dao.getEditeurById(ID_EDITEUR_GLENAT);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeur);
        Assert.assertEquals(editeur.getId(), ID_EDITEUR_GLENAT);
    }
}