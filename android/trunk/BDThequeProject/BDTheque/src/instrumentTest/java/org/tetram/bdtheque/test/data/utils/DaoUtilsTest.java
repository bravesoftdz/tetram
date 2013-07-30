package org.tetram.bdtheque.test.data.utils;

import junit.framework.TestCase;

import org.tetram.bdtheque.data.utils.DaoUtils;

public class DaoUtilsTest extends TestCase {

    @Override
    public void setUp() throws Exception {
        super.setUp();
    }

    @Override
    public void tearDown() throws Exception {
        super.tearDown();
    }

    public void testGetSQLAlias() throws Exception {
        assertEquals("getSQLAlias", "123456_1023", DaoUtils.getSQLAlias("123456", 1023));
        assertEquals("getSQLAlias", "12345678901234567890_1023", DaoUtils.getSQLAlias("12345678901234567890", 1023));
        assertEquals("getSQLAlias", "12345678901234567890_1023", DaoUtils.getSQLAlias("123456789012345678901234567890", 1023));
        assertEquals("getSQLAlias", "123456_1", DaoUtils.getSQLAlias("123456", 1));
    }
}
