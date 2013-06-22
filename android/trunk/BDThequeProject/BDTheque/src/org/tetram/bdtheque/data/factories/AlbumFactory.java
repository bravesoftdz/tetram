package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.AlbumBean;

public class AlbumFactory implements BeanFactory<AlbumBean> {
    @Nullable
    @Override
    public AlbumBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        return null;
    }
}
