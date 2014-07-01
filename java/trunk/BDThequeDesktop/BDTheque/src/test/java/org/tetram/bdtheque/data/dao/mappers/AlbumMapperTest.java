package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.utils.StringUtils;

public class AlbumMapperTest extends SpringTest {

    @Autowired
    private AlbumMapper mapper;

    @Autowired
    private SqlMapper sqlMapper;

    @SuppressWarnings("HardCodedStringLiteral")
    @Before
    public void setUp() {
        sqlMapper.execute("delete from editions where id_album = '" + StringUtils.UUIDToGUIDString(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11) + "' and extract(year from dc_editions) > 2013");
    }

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