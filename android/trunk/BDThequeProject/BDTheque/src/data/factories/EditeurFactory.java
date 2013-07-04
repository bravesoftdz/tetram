package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.EditeurBean;

public class EditeurFactory implements BeanFactory<EditeurBean> {
    @Nullable
    @Override
    public EditeurBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        EditeurBean bean = new EditeurBean();
        if (!loadFromCursor(context, cursor, mustExists, bean)) return null;
        return bean;
    }

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, EditeurBean bean) {
        return false;
    }
}
