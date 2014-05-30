package org.tetram.bdtheque.data.mappers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AlbumLite;

public class AlbumMapperTest extends DBTest {

    private AlbumMapper mapper;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        mapper = dbSession.getMapper(AlbumMapper.class);
    }

    @Test
    public void testGetAlbumLiteById() throws Exception {
        AlbumLite albumLite = mapper.getAlbumLiteById(ID_ALBUM_MAGASIN_GENERAL_TOME_11, null);
        Assert.assertNotNull(albumLite);
        Assert.assertEquals(ID_ALBUM_MAGASIN_GENERAL_TOME_11, albumLite.getId());
    }

    @Test
    public void testGetAlbumById() throws Exception {
        Album album = mapper.getAlbumById(ID_ALBUM_MAGASIN_GENERAL_TOME_11);
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