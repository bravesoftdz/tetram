package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.LoadDescriptor;

public interface BeanFactory<T extends CommonBean> {
    @SuppressWarnings({"BooleanMethodNameMustStartWithQuestion", "UnusedDeclaration"})
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, LoadDescriptor loadDescriptor, T bean);
}
