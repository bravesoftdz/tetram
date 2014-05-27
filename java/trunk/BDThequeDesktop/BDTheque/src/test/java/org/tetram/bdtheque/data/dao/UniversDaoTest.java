package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.data.bean.lite.UniversLite;

import java.util.List;

public class UniversDaoTest extends DaoTest {

    private UniversDao dao;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        dao = dbSession.getMapper(UniversDao.class);
    }

    @Test
    public void testGetUniversLiteById() throws Exception {
        UniversLite universLite = dao.getUniversLiteById(ID_UNIVERS_TROLLS_DE_TROY);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(universLite);
        Assert.assertEquals(universLite.getId(), ID_UNIVERS_TROLLS_DE_TROY);
    }

    @Test
    public void testGetListUniversLiteByParaBDId() throws Exception{
        List<UniversLite> lstUniversLite = dao.getListUniversLiteByParaBDId(ID_PARABD_SPIROU_BLOC_3D);
        Assert.assertFalse(lstUniversLite.isEmpty());
        Assert.assertNotNull(lstUniversLite.get(0).getId());
    }

    @Test
    public void testGetUniversById() throws Exception {
        Univers univers = dao.getUniversById(ID_UNIVERS_TROLLS_DE_TROY);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(univers);
        Assert.assertEquals(univers.getId(), ID_UNIVERS_TROLLS_DE_TROY);
    }
}