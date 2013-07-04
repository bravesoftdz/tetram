package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.AuteurBean;

public abstract class AuteurFactory implements BeanFactory<AuteurBean> {
    @Nullable
    @Override
    public AuteurBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        final AuteurBean bean = new AuteurBean();
        if (loadFromCursor(context, cursor, mustExists, bean)) return bean;
        return null;

    }

    @Override
    public abstract boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, AuteurBean bean);
}
