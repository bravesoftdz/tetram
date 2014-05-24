package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.bean.lite.CollectionLite;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

public class CollectionDaoTest extends DaoTest {

    public static final String ID_EDITEUR_GLENAT = "{C8EC600B-9BCA-41F7-AF2A-4FF6F33F48D9}";
    public static final String ID_COLLECTION_GENERATION_COMICS_PANINI = "{085B0C9C-7608-4B5E-A2B6-968D9FDB56E8}";
    protected CollectionDao dao;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        dao = dbSession.getMapper(CollectionDao.class);
    }

    @Test
    public void testGetCollectionLiteById() throws Exception {
        CollectionLite collectionLite = dao.getCollectionLiteById(StringUtils.GUIDStringToUUID(ID_COLLECTION_GENERATION_COMICS_PANINI));
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(collectionLite);
    }

    @Test
    public void testGetListCollectionLiteByEditeurId() throws Exception {
        List<CollectionLite> lstCollectionLite = dao.getListCollectionLiteByEditeurId(StringUtils.GUIDStringToUUID(ID_EDITEUR_GLENAT));
        Assert.assertFalse(lstCollectionLite.isEmpty());
    }

    @Test
    public void testGetCollectionById() throws Exception {
        Collection collection = dao.getCollectionById(StringUtils.GUIDStringToUUID(ID_COLLECTION_GENERATION_COMICS_PANINI));
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(collection);
    }
}