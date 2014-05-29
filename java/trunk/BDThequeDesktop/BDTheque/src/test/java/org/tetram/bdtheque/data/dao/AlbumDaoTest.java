package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.lite.AlbumLite;

public class AlbumDaoTest extends DaoTest {

    private AlbumDao dao;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        dao = dbSession.getMapper(AlbumDao.class);
    }

    @Test
    public void testGetAlbumLiteById() throws Exception {
        AlbumLite albumLite = dao.getAlbumLiteById(ID_ALBUM_MAGASIN_GENERAL_TOME_11, null);
        Assert.assertNotNull(albumLite);
        Assert.assertEquals(ID_ALBUM_MAGASIN_GENERAL_TOME_11, albumLite.getId());
    }

    @Test
    public void testGetAlbumById() throws Exception{
        Album album = dao.getAlbumById(ID_ALBUM_MAGASIN_GENERAL_TOME_11);
        Assert.assertNotNull(album);
        Assert.assertEquals(ID_ALBUM_MAGASIN_GENERAL_TOME_11, album.getId());
        Assert.assertNotNull(album.getSerie());
        Assert.assertNotNull(album.getEditions());
        Assert.assertEquals(2, album.getEditions().size());
        Assert.assertFalse(album.getScenaristes().isEmpty());
        Assert.assertNotNull(album.getAuteurs());
        Assert.assertFalse(album.getAuteurs().isEmpty());
        Assert.assertEquals(album.getAuteurs().size(), album.getScenaristes().size() + album.getDessinateurs().size() + album.getColoristes().size());
    }
}