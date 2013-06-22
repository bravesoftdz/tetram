package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.AuteurBean;

public class AuteurFactory implements BeanFactory<AuteurBean> {
    @Nullable
    @Override
    public AuteurBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        return null;
    }
}
