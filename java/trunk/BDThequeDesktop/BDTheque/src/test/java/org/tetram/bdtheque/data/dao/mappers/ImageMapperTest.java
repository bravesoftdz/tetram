package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.CouvertureLite;
import org.tetram.bdtheque.data.bean.PhotoLite;

import java.util.List;

public class ImageMapperTest extends DBTest {

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