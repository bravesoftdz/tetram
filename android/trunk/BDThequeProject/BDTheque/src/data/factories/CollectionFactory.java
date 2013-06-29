package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CollectionBean;

public class CollectionFactory implements BeanFactory<CollectionBean> {
    @Nullable
    @Override
    public CollectionBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        return null;
    }
}
