package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.utils.StringUtils;

public class GenreLiteDaoTest extends DBTest {

    @NonNls
    public static final String TEST_CREATE_GENRE = "test create genre";
    @NonNls
    public static final String TEST_UPDATE_GENRE = "test update genre";

    GenreLiteDao dao = Database.getInstance().getApplicationContext().getBean(GenreLiteDao.class);

    @Test
    public void testGet() throws Exception {
        GenreLite genre = dao.get(Constants.ID_GENRE_AVENTURES);
        Assert.assertNotNull(genre);
        Assert.assertNotNull(genre.getId());
        Assert.assertNotNull(genre.getGenre());
    }

    @Test
    public void testCreate() throws Exception {
        int rowCount;

        GenreLite genre;

        genre = new GenreLite();
        genre.setGenre(TEST_CREATE_GENRE);

        rowCount = dao.create(genre);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(genre.getId());
        Assert.assertNotEquals(StringUtils.GUID_NULL, genre.getId());

        genre = dao.get(genre.getId());
        Assert.assertEquals(TEST_CREATE_GENRE, genre.getGenre());

        genre.setGenre(TEST_UPDATE_GENRE);
        rowCount = dao.update(genre);
        Assert.assertEquals(1, rowCount);

        genre = dao.get(genre.getId());
        Assert.assertEquals(TEST_UPDATE_GENRE, genre.getGenre());

        rowCount = dao.delete(genre.getId());
        Assert.assertEquals(1, rowCount);

        genre = dao.get(genre.getId());
        Assert.assertNull(genre);
    }

    @Test(expected = ConsistencyException.class)
    public void testCreateIsUnique() throws Exception {
        @NonNls GenreLite genre = new GenreLite();
        genre.setGenre("Aventures");

        dao.create(genre);
        Assert.fail();
    }

    @Test(expected = ConsistencyException.class)
    public void testUpdateIsUnique() throws Exception {
        @NonNls GenreLite genre = new GenreLite();
        genre.setGenre("Aventures");
        genre.setId(StringUtils.GUID_FULL);

        dao.update(genre);
        Assert.fail();
    }
}