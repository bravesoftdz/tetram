package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.bean.lite.EditeurLite;
import org.tetram.bdtheque.utils.StringUtils;

public class EditeurDaoTest extends DaoTest {

    public static final String ID_EDITEUR_GLENAT = "{C8EC600B-9BCA-41F7-AF2A-4FF6F33F48D9}";
    protected EditeurDao dao;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        dao = dbSession.getMapper(EditeurDao.class);
    }

    @Test
    public void testGetEditeurLiteById() throws Exception {
        EditeurLite editeurLite = dao.getEditeurLiteById(StringUtils.GUIDStringToUUID(ID_EDITEUR_GLENAT));
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeurLite);
    }

    @Test
    public void testGetEditeurById() throws Exception {
        Editeur editeur = dao.getEditeurById(StringUtils.GUIDStringToUUID(ID_EDITEUR_GLENAT));
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeur);
    }
}