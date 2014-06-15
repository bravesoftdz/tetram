package org.tetram.bdtheque.data.dao;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.Edition;

public class EditionDaoImplTest extends SpringTest {

    @Autowired
    private EditionDao editionDao;
    @Autowired
    private EditeurLiteDao editeurLiteDao;

    @Test
    public void testSave() throws Exception {
        Edition edition = new Edition();
        edition.setIdAlbum(Constants.ID_ALBUM_MAGASIN_GENERAL_TOME_11);
        edition.setEditeur(editeurLiteDao.get(Constants.ID_EDITEUR_DELCOURT));

        editionDao.save(edition);
    }
}