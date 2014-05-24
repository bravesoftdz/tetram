package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.session.SqlSession;
import org.junit.Before;
import org.tetram.bdtheque.data.Database;

/**
 * Created by Thierry on 24/05/2014.
 */
public class DaoTest {
    protected SqlSession dbSession;
    private Database db;

    @Before
    public void setUp() throws Exception {
        db = new Database();
        dbSession = db.getSession();
    }
}
