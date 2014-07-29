/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreLiteDaoTest.java
 * Last modified by Tetram, on 2014-07-29T11:02:08CEST
 */

package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.data.dao.mappers.SqlMapper;
import org.tetram.bdtheque.utils.TypeUtils;

public class GenreLiteDaoTest extends SpringTest {

    @Autowired
    private GenreLiteDao dao;
    @Autowired
    private SqlMapper sqlMapper;

    @SuppressWarnings("HardCodedStringLiteral")
    @Before
    public void setUp() {
        sqlMapper.execute("delete from genres where genre = '" + Constants.TEST_CREATE + "'");
    }

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
        Assert.assertNotEquals(TypeUtils.GUID_NULL, genre.getId());

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
        genre.setId(TypeUtils.GUID_FULL);

        dao.save(genre);
        Assert.fail();
    }
}