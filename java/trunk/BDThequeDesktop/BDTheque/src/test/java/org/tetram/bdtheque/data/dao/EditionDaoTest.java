package org.tetram.bdtheque.data.dao;

import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.Edition;
import org.tetram.bdtheque.data.dao.mappers.SqlMapper;
import org.tetram.bdtheque.utils.StringUtils;

public class EditionDaoTest extends SpringTest {

    @Autowired
    private EditionDao editionDao;
    @Autowired
    private EditeurDao editeurDao;

    @Autowired
    private SqlMapper sqlMapper;

    @SuppressWarnings("HardCodedStringLiteral")
    @Before
    public void setUp() {
        sqlMapper.execute("delete from editions where id_album = '" + StringUtils.UUIDToGUIDString(Constants.ID_ALBUM_SPIROU_GALLERIE_DES_ILLUSTRES) + "' and extract(year from dc_editions) > 2013");
    }

    @Test
    public void testSave() throws Exception {
        Edition edition = new Edition();
        edition.setIdAlbum(Constants.ID_ALBUM_SPIROU_GALLERIE_DES_ILLUSTRES);
        edition.setEditeur(editeurDao.get(Constants.ID_EDITEUR_DELCOURT));

        editionDao.save(edition);
    }
}