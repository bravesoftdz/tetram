package org.tetram.bdtheque.data.mappers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.CouvertureLite;
import org.tetram.bdtheque.data.bean.PhotoLite;

import java.util.List;

public class ImageMapperTest extends DBTest {

    ImageMapper mapper;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        mapper = dbSession.getMapper(ImageMapper.class);
    }

    @Test
    public void testGetListCouvertureLiteByEditionId() throws Exception {
        List<CouvertureLite> lstCouvertureLite = mapper.getListCouvertureLiteByEditionId(ID_EDITION_SILLAGE_TOME_16);
        Assert.assertFalse(lstCouvertureLite.isEmpty());
        Assert.assertNotNull(lstCouvertureLite.get(0).getId());
        Assert.assertNotEquals("", lstCouvertureLite.get(0).getCategorie().getTexte());
    }

    @Test
    public void testGetListPhotoLiteByParaBDId() throws Exception {
        List<PhotoLite> lstPhotoLite = mapper.getListPhotoLiteByParaBDId(ID_PARABD_SPIROU_BLOC_3D);
        Assert.assertFalse(lstPhotoLite.isEmpty());
        Assert.assertNotNull(lstPhotoLite.get(0).getId());
        Assert.assertNotEquals("", lstPhotoLite.get(0).getCategorie().getTexte());
    }
}