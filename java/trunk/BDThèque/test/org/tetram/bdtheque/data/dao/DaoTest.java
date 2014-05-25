package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.session.SqlSession;
import org.junit.After;
import org.junit.Before;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class DaoTest {

    public static final UUID ID_EDITEUR_GLENAT = StringUtils.GUIDStringToUUID("{C8EC600B-9BCA-41F7-AF2A-4FF6F33F48D9}");
    public static final UUID ID_COLLECTION_GENERATION_COMICS_PANINI = StringUtils.GUIDStringToUUID("{085B0C9C-7608-4B5E-A2B6-968D9FDB56E8}");
    protected static final UUID ID_EDITION_SILLAGE_TOME_16 = StringUtils.GUIDStringToUUID("{C283B013-6FD6-4CC3-884D-034807EB7E8F}");
    protected static final UUID ID_PARABD_SPIROU_BLOC_3D = StringUtils.GUIDStringToUUID("{D7BB36F8-75DA-46C9-9DBD-EB9FFA110E49}");
    protected static final UUID ID_UNIVERS_TROLLS_DE_TROY = StringUtils.GUIDStringToUUID("{484689EB-72CC-4957-A912-621019EEC526}");

    protected SqlSession dbSession;

    @Before
    public void setUp() throws Exception {
        Database db = new Database();
        dbSession = db.getSession();
    }

    @After
    public void tearDown() throws Exception {
        if (dbSession != null) dbSession.close();
    }
}
