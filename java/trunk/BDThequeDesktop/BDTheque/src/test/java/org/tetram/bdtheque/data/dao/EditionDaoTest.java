package org.tetram.bdtheque.data.dao;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.Edition;

public class EditionDaoTest extends SpringTest {

    @Autowired
    private EditionDao editionDao;
    @Autowired
    private EditeurDao editeurDao;

    @Test
    public void testSave() throws Exception {
        Edition edition = new Edition();
        edition.setIdAlbum(Constants.ID_ALBUM_SPIROU_GALLERIE_DES_ILLUSTRES);
        edition.setEditeur(editeurDao.get(Constants.ID_EDITEUR_DELCOURT));

        editionDao.save(edition);
    }
}