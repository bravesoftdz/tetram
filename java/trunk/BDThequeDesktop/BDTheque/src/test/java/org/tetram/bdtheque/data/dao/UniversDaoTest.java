package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.session.SqlSession;
import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.data.dao.mappers.SqlMapper;
import org.tetram.bdtheque.utils.StringUtils;

public class UniversDaoTest extends SpringTest {

    @Autowired
    private SqlMapper sqlMapper;

    @Autowired
    private UniversDao dao; // = Database.getInstance().getApplicationContext().getBean(UniversDao.class);
    @Autowired
    private UniversLiteDao daoUnivers; // = Database.getInstance().getApplicationContext().getBean(UniversLiteDao.class);

    @Test
    public void testGet() throws Exception {
        Univers univers = dao.get(Constants.ID_UNIVERS_TROLLS_DE_TROY);
        Assert.assertNotNull(univers);
        Assert.assertNotNull(univers.getId());
        Assert.assertNotNull(univers.getNomUnivers());
        Assert.assertNotNull(univers.getUniversParent());
        Assert.assertNotNull(univers.getIdUniversParent());
        Assert.assertNotNull(univers.getUniversParent().getNomUnivers());
    }

    @Test
    public void testCreateWithParent() throws Exception {
        int rowCount;

        sqlMapper.execute("delete from univers where nomunivers = '" + Constants.TEST_CREATE + "'");

        Univers univers;

        univers = new Univers();
        univers.setNomUnivers(Constants.TEST_CREATE);
        univers.setUniversParent(daoUnivers.get(Constants.ID_UNIVERS_TROLLS_DE_TROY));

        rowCount = dao.save(univers);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(univers.getId());
        Assert.assertNotEquals(StringUtils.GUID_NULL, univers.getId());

        Univers oldUnivers = univers;
        univers = dao.get(univers.getId());
        Assert.assertEquals(0, oldUnivers.fullCompare(univers));

        Assert.assertEquals(Constants.TEST_CREATE, univers.getNomUnivers());
        Assert.assertNotNull(univers.getUniversParent());
        Assert.assertEquals(Constants.ID_UNIVERS_TROLLS_DE_TROY, univers.getUniversParent().getId());

        univers.setNomUnivers(Constants.TEST_UPDATE);
        rowCount = dao.save(univers);
        Assert.assertEquals(1, rowCount);

        univers = dao.get(univers.getId());
        Assert.assertEquals(Constants.TEST_UPDATE, univers.getNomUnivers());

        rowCount = dao.delete(univers.getId());
        Assert.assertEquals(1, rowCount);

        univers = dao.get(univers.getId());
        Assert.assertNull(univers);
    }

    @Test
    public void testCreateWithoutParent() throws Exception {
        int rowCount;

        sqlMapper.execute("delete from univers where nomunivers = '" + Constants.TEST_CREATE + "'");

        Univers univers;

        univers = new Univers();
        univers.setNomUnivers(Constants.TEST_CREATE);

        rowCount = dao.save(univers);
        Assert.assertEquals(1, rowCount);
        Assert.assertNotNull(univers.getId());
        Assert.assertNotEquals(StringUtils.GUID_NULL, univers.getId());

        univers = dao.get(univers.getId());
        Assert.assertEquals(Constants.TEST_CREATE, univers.getNomUnivers());
        Assert.assertNull(univers.getUniversParent());
        Assert.assertNull(univers.getIdUniversParent());

        univers.setNomUnivers(Constants.TEST_UPDATE);
        rowCount = dao.save(univers);
        Assert.assertEquals(1, rowCount);

        univers = dao.get(univers.getId());
        Assert.assertEquals(Constants.TEST_UPDATE, univers.getNomUnivers());

        rowCount = dao.delete(univers.getId());
        Assert.assertEquals(1, rowCount);

        univers = dao.get(univers.getId());
        Assert.assertNull(univers);
    }

    @Test(expected = ConsistencyException.class)
    public void testCreateIsUnique() throws Exception {
        @NonNls Univers univers = new Univers();
        univers.setNomUnivers(Constants.NOM_UNIVERS_TROLLS_DE_TROY);

        dao.save(univers);
        Assert.fail();
    }

    @Test(expected = ConsistencyException.class)
    public void testUpdateIsUnique() throws Exception {
        @NonNls Univers univers = new Univers();
        univers.setNomUnivers(Constants.NOM_UNIVERS_TROLLS_DE_TROY);
        univers.setId(StringUtils.GUID_FULL);

        dao.save(univers);
        Assert.fail();
    }

}