package org.tetram.bdtheque.data.mappers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.ParaBD;

public class ParaBDMapperTest extends DBTest {

    private ParaBDMapper mapper;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        mapper = dbSession.getMapper(ParaBDMapper.class);
    }

    @Test
    public void testGetParaBDLiteById() throws Exception {

    }

    @Test
    public void testGetParaBDById() throws Exception {
        ParaBD paraBD = mapper.getParaBDById(ID_PARABD_SPIROU_BLOC_3D);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(paraBD);
        Assert.assertEquals(ID_PARABD_SPIROU_BLOC_3D, paraBD.getId());
        Assert.assertFalse(paraBD.getUnivers().isEmpty());
        Assert.assertNotNull(paraBD.getUnivers().get(0).getId());
        Assert.assertFalse(paraBD.getPhotos().isEmpty());
        Assert.assertNotNull(paraBD.getPhotos().get(0).getId());
        Assert.assertNotNull(paraBD.getCategorieParaBD());
        Assert.assertNotEquals("", paraBD.getCategorieParaBD().getTexte());
    }
}