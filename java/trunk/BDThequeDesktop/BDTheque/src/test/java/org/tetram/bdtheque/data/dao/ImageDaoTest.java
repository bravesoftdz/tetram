package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.bean.lite.CouvertureLite;
import org.tetram.bdtheque.data.bean.lite.PhotoLite;

import java.util.List;

public class ImageDaoTest extends DaoTest {

    ImageDao dao;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        dao = dbSession.getMapper(ImageDao.class);
    }

    @Test
    public void testGetListCouvertureLiteByEditionId() throws Exception {
        List<CouvertureLite> lstCouvertureLite = dao.getListCouvertureLiteByEditionId(ID_EDITION_SILLAGE_TOME_16);
        Assert.assertFalse(lstCouvertureLite.isEmpty());
        Assert.assertNotNull(lstCouvertureLite.get(0).getId());
        Assert.assertNotEquals("", lstCouvertureLite.get(0).getCategorie().getTexte());
    }

    @Test
    public void testGetListPhotoLiteByParaBDId() throws Exception {
        List<PhotoLite> lstPhotoLite = dao.getListPhotoLiteByParaBDId(ID_PARABD_SPIROU_BLOC_3D);
        Assert.assertFalse(lstPhotoLite.isEmpty());
        Assert.assertNotNull(lstPhotoLite.get(0).getId());
        Assert.assertNotEquals("", lstPhotoLite.get(0).getCategorie().getTexte());
    }
}