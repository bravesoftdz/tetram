package org.tetram.bdtheque.data.dao.mappers;

import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.utils.StringUtils;

public class GenreMapperTest extends DBTest {

    @NonNls
    public static final String TEST_CREATE_GENRE = "test create genre";
    @NonNls
    public static final String TEST_UPDATE_GENRE = "test update genre";

    GenreMapper mapper = Database.getInstance().getApplicationContext().getBean(GenreMapper.class);

    @Test
    public void testGetGenreLiteById() throws Exception {
        GenreLite genre = mapper.getGenreLiteById(Constants.ID_GENRE_AVENTURES);
        Assert.assertNotNull(genre);
        Assert.assertNotNull(genre.getId());
        Assert.assertNotNull(genre.getGenre());
    }

    @Test
    public void testGetListGenreBySerieId() throws Exception {

    }

    @Test
    public void testCreateGenre() throws Exception {
        int rowCount;

        GenreLite genre;
        genre = new GenreLite();
        genre.setGenre(TEST_CREATE_GENRE);

        rowCount = mapper.createGenreLite(genre);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(genre.getId());
        Assert.assertNotEquals(StringUtils.GUID_NULL, genre.getId());

        genre = mapper.getGenreLiteById(genre.getId());
        Assert.assertEquals(TEST_CREATE_GENRE, genre.getGenre());

        genre.setGenre(TEST_UPDATE_GENRE);
        rowCount = mapper.updateGenreLite(genre);
        Assert.assertEquals(1, rowCount);

        genre = mapper.getGenreLiteById(genre.getId());
        Assert.assertEquals(TEST_UPDATE_GENRE, genre.getGenre());

        rowCount = mapper.deleteGenreLite(genre.getId());
        Assert.assertEquals(1, rowCount);

        genre = mapper.getGenreLiteById(genre.getId());
        Assert.assertNull(genre);
    }
}