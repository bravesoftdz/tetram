/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreMapperTest.java
 * Last modified by Tetram, on 2014-07-31T16:50:01CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.utils.TypeUtils;

public class GenreMapperTest extends SpringTest {

    @Autowired
    private GenreMapper mapper;

    @Test
    public void testGetGenreLiteById() throws Exception {
        GenreLite genre = mapper.getGenreLiteById(Constants.ID_GENRE_AVENTURES);
        Assert.assertNotNull(genre);
        Assert.assertNotNull(genre.getId());
        Assert.assertNotNull(genre.getNomGenre());
    }

    @Test
    public void testGetListGenreBySerieId() throws Exception {

    }

    @Test
    public void testCreateGenre() throws Exception {
        int rowCount;

        GenreLite genre;
        genre = new GenreLite();
        genre.setNomGenre(Constants.TEST_CREATE);

        rowCount = mapper.createGenreLite(genre);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(genre.getId());
        Assert.assertNotEquals(TypeUtils.GUID_NULL, genre.getId());

        genre = mapper.getGenreLiteById(genre.getId());
        Assert.assertEquals(Constants.TEST_CREATE, genre.getNomGenre());

        genre.setNomGenre(Constants.TEST_UPDATE);
        rowCount = mapper.updateGenreLite(genre);
        Assert.assertEquals(1, rowCount);

        genre = mapper.getGenreLiteById(genre.getId());
        Assert.assertEquals(Constants.TEST_UPDATE, genre.getNomGenre());

        rowCount = mapper.deleteGenreLite(genre.getId());
        Assert.assertEquals(1, rowCount);

        genre = mapper.getGenreLiteById(genre.getId());
        Assert.assertNull(genre);
    }
}