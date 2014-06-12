package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AlbumLite;

public class AlbumMapperTest extends DBTest {

    @Autowired
    private AlbumMapper mapper;

    @Test
    public void testGetAlbumLiteById() throws Exception {
        AlbumLite albumLite = mapper.getAlbumLiteById(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11, null);
        Assert.assertNotNull(albumLite);
        Assert.assertEquals(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11, albumLite.getId());
    }

    @Test
    public void testGetAlbumById() throws Exception {
        Album album = mapper.getAlbumById(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11);
        Assert.assertNotNull(album);
        Assert.assertEquals(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11, album.getId());
        Assert.assertNotNull(album.getSerie());
        Assert.assertNotNull(album.getEditions());
        Assert.assertEquals(2, album.getEditions().size());
        Assert.assertFalse(album.getScenaristes().isEmpty());
        Assert.assertNotNull(album.getAuteurs());
        Assert.assertFalse(album.getAuteurs().isEmpty());
        Assert.assertEquals(album.getAuteurs().size(), album.getScenaristes().size() + album.getDessinateurs().size() + album.getColoristes().size());
    }
}