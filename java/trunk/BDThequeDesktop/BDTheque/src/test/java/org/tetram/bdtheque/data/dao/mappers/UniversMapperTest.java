package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.data.bean.UniversLite;

import java.util.List;

public class UniversMapperTest extends DBTest {

    @Autowired
    private UniversMapper mapper;

    @Test
    public void testGetUniversLiteById() throws Exception {
        UniversLite universLite = mapper.getUniversLiteById(Constants.ID_UNIVERS_TROLLS_DE_TROY);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(universLite);
        Assert.assertEquals(Constants.ID_UNIVERS_TROLLS_DE_TROY, universLite.getId());
    }

    @Test
    public void testGetListUniversLiteByParaBDId() throws Exception {
        List<UniversLite> lstUniversLite = mapper.getListUniversLiteByParaBDId(Constants.ID_PARABD_SPIROU_BLOC_3D);
        Assert.assertFalse(lstUniversLite.isEmpty());
        Assert.assertNotNull(lstUniversLite.get(0).getId());
    }

    @Test
    public void testGetListUniversLiteAlbumId() throws Exception {
        List<UniversLite> lstUniversLite = mapper.getListUniversLiteByAlbumId(Constants.ID_ALBUM_SPIROU_GALLERIE_DES_ILLUSTRES);
        Assert.assertFalse(lstUniversLite.isEmpty());
        Assert.assertNotNull(lstUniversLite.get(0).getId());
    }

    @Test
    public void testGetListUniversLiteBySerieId() throws Exception {
        List<UniversLite> lstUniversLite = mapper.getListUniversLiteBySerieId(Constants.ID_SERIE_LANFEUST_DE_TROY);
        Assert.assertFalse(lstUniversLite.isEmpty());
        Assert.assertNotNull(lstUniversLite.get(0).getId());
    }

    @Test
    public void testGetUniversById() throws Exception {
        Univers univers = mapper.getUniversById(Constants.ID_UNIVERS_TROLLS_DE_TROY);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(univers);
        Assert.assertEquals(Constants.ID_UNIVERS_TROLLS_DE_TROY, univers.getId());
    }
}