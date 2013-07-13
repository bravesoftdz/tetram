package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AuteurBean;

public abstract class AuteurFactory extends BeanFactoryImpl<AuteurBean> {
    @Override
    public abstract boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, AuteurBean bean);
}
