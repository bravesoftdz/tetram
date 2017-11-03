/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * PhotoLiteDaoTest.java
 * Last modified by Tetram, on 2014-07-29T11:02:08CEST
 */

package org.tetram.bdtheque.data.dao;

import org.apache.commons.io.IOUtils;
import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.PhotoLite;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

public class PhotoLiteDaoTest extends SpringTest {

    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_DATA_DAO_PHOTO_SPIROU_CUBE_3D_JPG = "/org/tetram/bdtheque/data/dao/photo-spirou_cube_3d.jpg";

    @Autowired
    private PhotoLiteDao photoLiteDao;

    @Test
    public void testGetPhotoStream() throws Exception {
        PhotoLite photoLite = photoLiteDao.get(Constants.ID_PHOTO_SPIROU_BLOC_3D);
        Assert.assertNotNull(photoLite);

        byte[] photoStream = photoLiteDao.getImageStream(photoLite, null, null, false);

/*
        try (FileOutputStream f = new FileOutputStream("d:\\photo-spirou_cube_3d.jpg")) {
            f.write(photoStream);
        }
*/

        File f = new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_DATA_DAO_PHOTO_SPIROU_CUBE_3D_JPG).toURI());
        ByteArrayInputStream resultStream = new ByteArrayInputStream(photoStream);
        try (InputStream stream = new FileInputStream(f)) {
            Assert.assertTrue(IOUtils.contentEquals(resultStream, stream));
        }
    }
}