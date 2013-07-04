package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;

public interface BeanFactory<T extends CommonBean> {
    @Nullable
    public T loadFromCursor(Context context, Cursor cursor, boolean mustExists);

    @SuppressWarnings("BooleanMethodNameMustStartWithQuestion")
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, T bean);
}
