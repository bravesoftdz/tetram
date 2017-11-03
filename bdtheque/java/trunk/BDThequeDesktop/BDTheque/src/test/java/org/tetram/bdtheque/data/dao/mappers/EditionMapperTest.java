/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EditionMapperTest.java
 * Last modified by Tetram, on 2014-08-01T12:25:23CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.Edition;
import org.tetram.bdtheque.data.bean.EditionLite;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

public class EditionMapperTest extends SpringTest {

    @Autowired
    private EditionMapper mapper;

    @Autowired
    private SqlMapper sqlMapper;

    @SuppressWarnings("HardCodedStringLiteral")
    @Before
    public void setUp() {
        sqlMapper.execute("delete from editions where id_album = '" + StringUtils.UUIDToGUIDString(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11) + "' and extract(year from dc_editions) > 2013");
    }


    @Test
    public void testGetEditionLiteById() throws Exception {
        EditionLite editionLite = mapper.getEditionLiteById(Constants.ID_EDITION_SILLAGE_TOME_16);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editionLite);
        Assert.assertEquals(Constants.ID_EDITION_SILLAGE_TOME_16, editionLite.getId());
    }

    @Test
    public void testGetListEditionByAlbumId() throws Exception {
        List<Edition> lstEditionLite = mapper.getListEditionByAlbum(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11, null);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(lstEditionLite);
        Assert.assertEquals(2, lstEditionLite.size());
        Assert.assertEquals(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11, lstEditionLite.get(0).getIdAlbum());
        Assert.assertEquals(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11, lstEditionLite.get(1).getIdAlbum());
    }

    @Test
    public void testGetEditionById() throws Exception {
        Edition edition = mapper.getEditionById(Constants.ID_EDITION_SILLAGE_TOME_16);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(edition);
        Assert.assertEquals(Constants.ID_EDITION_SILLAGE_TOME_16, edition.getId());
        Assert.assertNotNull(edition.getEditeur());
        Assert.assertNotNull(edition.getCollection());
        Assert.assertFalse(edition.getCouvertures().isEmpty());
        Assert.assertNotNull(edition.getCouvertures().get(0).getId());
    }
}