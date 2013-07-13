package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.CollectionBean;

public class CollectionFactory extends BeanFactoryImpl<CollectionBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, CollectionBean bean) {
        return false;
    }
}
