package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.bean.Edition;
import org.tetram.bdtheque.data.bean.lite.EditionLite;

import java.util.List;

public class EditionDaoTest extends DaoTest {

    private EditionDao dao;

    @Before
    public void setUp() throws Exception {
        super.setUp();
        dao = dbSession.getMapper(EditionDao.class);
    }

    @Test
    public void testGetEditionLiteById() throws Exception {
        EditionLite editionLite = dao.getEditionLiteById(ID_EDITION_SILLAGE_TOME_16);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editionLite);
        Assert.assertEquals(ID_EDITION_SILLAGE_TOME_16, editionLite.getId());
    }

    @Test
    public void testGetListEditionByAlbumId() throws Exception {
        List<Edition> lstEditionLite = dao.getListEditionByAlbumId(ID_ALBUM_MAGASIN_GENERAL_TOME_11, null);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(lstEditionLite);
        Assert.assertEquals(2, lstEditionLite.size());
        Assert.assertEquals(ID_ALBUM_MAGASIN_GENERAL_TOME_11, lstEditionLite.get(0).getIdAlbum());
        Assert.assertEquals(ID_ALBUM_MAGASIN_GENERAL_TOME_11, lstEditionLite.get(1).getIdAlbum());
    }

    @Test
    public void testGetEditionById() throws Exception {
        Edition edition = dao.getEditionById(ID_EDITION_SILLAGE_TOME_16);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(edition);
        Assert.assertEquals(ID_EDITION_SILLAGE_TOME_16, edition.getId());
        Assert.assertNotNull(edition.getEditeur());
        Assert.assertNotNull(edition.getCollection());
        Assert.assertFalse(edition.getCouvertures().isEmpty());
        Assert.assertNotNull(edition.getCouvertures().get(0).getId());
    }
}