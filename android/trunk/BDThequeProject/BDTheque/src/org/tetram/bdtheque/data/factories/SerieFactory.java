package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.SerieBean;

public class SerieFactory implements BeanFactory<SerieBean> {
    @Nullable
    @Override
    public SerieBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        return null;
    }
}
