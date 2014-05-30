package org.tetram.bdtheque.data.mappers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.bean.EditeurLite;

public class EditeurMapperTest extends DBTest {

    protected EditeurMapper mapper;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        mapper = dbSession.getMapper(EditeurMapper.class);
    }

    @Test
    public void testGetEditeurLiteById() throws Exception {
        EditeurLite editeurLite = mapper.getEditeurLiteById(ID_EDITEUR_GLENAT);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeurLite);
        Assert.assertEquals(ID_EDITEUR_GLENAT, editeurLite.getId());
    }

    @Test
    public void testGetEditeurById() throws Exception {
        Editeur editeur = mapper.getEditeurById(ID_EDITEUR_GLENAT);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeur);
        Assert.assertEquals(ID_EDITEUR_GLENAT, editeur.getId());
    }
}