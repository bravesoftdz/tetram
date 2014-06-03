package org.tetram.bdtheque.data.dao.mappers;

import org.junit.Assert;
import org.junit.Test;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.bean.EditeurLite;

public class EditeurMapperTest extends DBTest {

    protected EditeurMapper mapper = Database.getInstance().getApplicationContext().getBean(EditeurMapper.class);

    @Test
    public void testGetEditeurLiteById() throws Exception {
        EditeurLite editeurLite = mapper.getEditeurLiteById(Constants.ID_EDITEUR_GLENAT);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeurLite);
        Assert.assertEquals(Constants.ID_EDITEUR_GLENAT, editeurLite.getId());
    }

    @Test
    public void testGetEditeurById() throws Exception {
        Editeur editeur = mapper.getEditeurById(Constants.ID_EDITEUR_GLENAT);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeur);
        Assert.assertEquals(Constants.ID_EDITEUR_GLENAT, editeur.getId());
    }
}