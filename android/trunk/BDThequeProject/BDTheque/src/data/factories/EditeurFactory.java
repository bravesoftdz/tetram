package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.EditeurBean;

public class EditeurFactory implements BeanFactory<EditeurBean> {
    @Nullable
    @Override
    public EditeurBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        return null;
    }
}
