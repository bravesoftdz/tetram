package org.tetram.bdtheque.data.dao;

import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.SpringTest;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.dao.mappers.SqlMapper;

public class AlbumDaoTest extends SpringTest {
    @Autowired
    private SqlMapper sqlMapper;

    @SuppressWarnings("HardCodedStringLiteral")
    @Before
    public void setUp() {
        sqlMapper.execute("delete from albums where titrealbum = '" + Constants.TEST_CREATE + "'");
    }

    @Test
    public void testCreate() {

    }

}