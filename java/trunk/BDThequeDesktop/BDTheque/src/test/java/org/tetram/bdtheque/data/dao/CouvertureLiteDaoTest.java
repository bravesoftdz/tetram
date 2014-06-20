package org.tetram.bdtheque.data.dao;

import org.apache.commons.io.IOUtils;
import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.CouvertureLite;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

public class CouvertureLiteDaoTest extends SpringTest {

    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_DATA_DAO_PLANCHE_NOMAD_JPG = "/org/tetram/bdtheque/data/dao/planche-nomad.jpg";

    @Autowired
    private CouvertureLiteDao couvertureLiteDao;

    @Test
    public void testGetCouvertureStream() throws Exception {
        CouvertureLite couvertureLite = couvertureLiteDao.get(Constants.ID_COUVERTURE_NOMAD);
        Assert.assertNotNull(couvertureLite);

        byte[] couvertureStream = couvertureLiteDao.getImageStream(couvertureLite, null, null, false);

/*
        try (FileOutputStream f = new FileOutputStream("d:\\planche-nomad.jpg")) {
            f.write(couvertureStream);
        }
*/

        File f = new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_DATA_DAO_PLANCHE_NOMAD_JPG).toURI());
        ByteArrayInputStream resultStream = new ByteArrayInputStream(couvertureStream);
        try (InputStream stream = new FileInputStream(f)) {
            Assert.assertTrue(IOUtils.contentEquals(resultStream, stream));
        }
    }
}