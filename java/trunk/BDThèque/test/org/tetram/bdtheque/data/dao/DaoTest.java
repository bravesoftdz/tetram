package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.session.SqlSession;
import org.junit.Before;
import org.tetram.bdtheque.data.Database;

/**
 * Created by Thierry on 24/05/2014.
 */
public class DaoTest {
    public static final String ID_EDITEUR_GLENAT = "{C8EC600B-9BCA-41F7-AF2A-4FF6F33F48D9}";
    public static final String ID_COLLECTION_GENERATION_COMICS_PANINI = "{085B0C9C-7608-4B5E-A2B6-968D9FDB56E8}";

    protected SqlSession dbSession;
    private Database db;

    @Before
    public void setUp() throws Exception {
        db = new Database();
        dbSession = db.getSession();
    }
}
