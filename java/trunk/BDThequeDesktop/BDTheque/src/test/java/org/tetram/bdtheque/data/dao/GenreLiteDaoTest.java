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
        genre.setGenre(Constants.TEST_CREATE);

        rowCount = dao.save(genre);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(genre.getId());
        Assert.assertNotEquals(StringUtils.GUID_NULL, genre.getId());

        genre = dao.get(genre.getId());
        Assert.assertEquals(Constants.TEST_CREATE, genre.getGenre());

        genre.setGenre(Constants.TEST_UPDATE);
        rowCount = dao.save(genre);
        Assert.assertEquals(1, rowCount);

        genre = dao.get(genre.getId());
        Assert.assertEquals(Constants.TEST_UPDATE, genre.getGenre());

        rowCount = dao.delete(genre.getId());
        Assert.assertEquals(1, rowCount);

        genre = dao.get(genre.getId());
        Assert.assertNull(genre);
    }

    @Test(expected = ConsistencyException.class)
    public void testCreateIsUnique() throws Exception {
        @NonNls GenreLite genre = new GenreLite();
        genre.setGenre(Constants.NOM_GENRE_AVENTURES);

        dao.save(genre);
        Assert.fail();
    }

    @Test(expected = ConsistencyException.class)
    public void testUpdateIsUnique() throws Exception {
        @NonNls GenreLite genre = new GenreLite();
        genre.setGenre(Constants.NOM_GENRE_AVENTURES);
        genre.setId(StringUtils.GUID_FULL);

        dao.save(genre);
        Assert.fail();
    }
}