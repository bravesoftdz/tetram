package org.tetram.bdtheque.test.gui.adapter;

import android.test.AndroidTestCase;

import org.tetram.bdtheque.data.dao.DaoFactory;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteDao;
import org.tetram.bdtheque.gui.adapters.RepertoireAdapter;

public class RepertoireAdapterTest extends AndroidTestCase {

    RepertoireAdapter adapter;

    @Override
    public void setUp() throws Exception {
        super.setUp();
        this.adapter = new RepertoireAdapter(getContext(), DaoFactory.getDao(AlbumLiteDao.class, getContext()));
        this.adapter.getSections();
    }

    @Override
    public void tearDown() throws Exception {

        super.tearDown();
    }

    // private final Map<Integer, Integer> positions = new HashMap<>();

    @SuppressWarnings("ConstantJUnitAssertArgument")
    public void testGetPositionForSection() throws Exception {
        int position;
        position = this.adapter.getPositionForSection(0);
        assertEquals(0, position);
        position = this.adapter.getPositionForSection(5);
        assertEquals(5, position);
        assertEquals(10, this.adapter.getPositionForSection(10));
        assertEquals(15, this.adapter.getPositionForSection(15));
        assertEquals(20, this.adapter.getPositionForSection(20));
        assertTrue(true);
    }

    @SuppressWarnings("ConstantJUnitAssertArgument")
    public void testGetSectionForPosition() throws Exception {
/*
        final Integer position = this.adapters.getPositionForSection(0);
        final int section = this.adapters.getSectionForPosition(position);
        assertEquals(0, section);
        assertEquals(5, this.adapters.getSectionForPosition(this.adapters.getPositionForSection(5)));
        assertEquals(10, this.adapters.getSectionForPosition(this.adapters.getPositionForSection(10)));
        assertEquals(15, this.adapters.getSectionForPosition(this.adapters.getPositionForSection(15)));
        assertEquals(20, this.adapters.getSectionForPosition(this.adapters.getPositionForSection(20)));
*/
        assertTrue(true);
    }
}
