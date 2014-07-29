/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ImageMapperTest.java
 * Last modified by Tetram, on 2014-07-29T11:02:08CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.CouvertureLite;
import org.tetram.bdtheque.data.bean.PhotoLite;

import java.util.List;

public class ImageMapperTest extends SpringTest {

    @Autowired
    private ImageMapper mapper;

    @Test
    public void testGetListCouvertureLiteByEditionId() throws Exception {
        List<CouvertureLite> lstCouvertureLite = mapper.getListCouvertureLiteByEditionId(Constants.ID_EDITION_SILLAGE_TOME_16);
        Assert.assertFalse(lstCouvertureLite.isEmpty());
        Assert.assertNotNull(lstCouvertureLite.get(0).getId());
        Assert.assertNotEquals("", lstCouvertureLite.get(0).getCategorie().getTexte());
    }

    @Test
    public void testGetListPhotoLiteByParaBDId() throws Exception {
        List<PhotoLite> lstPhotoLite = mapper.getListPhotoLiteByParaBDId(Constants.ID_PARABD_SPIROU_BLOC_3D);
        Assert.assertFalse(lstPhotoLite.isEmpty());
        Assert.assertNotNull(lstPhotoLite.get(0).getId());
        Assert.assertNotEquals("", lstPhotoLite.get(0).getCategorie().getTexte());
    }
}