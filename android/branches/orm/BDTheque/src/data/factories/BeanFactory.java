package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.utils.DaoUtils;

public interface BeanFactory<T extends CommonBean> {
    @Nullable
    public T loadFromCursor(Context context, Cursor cursor, boolean inline, DaoUtils.LoadDescriptor loadDescriptor);

    @SuppressWarnings("BooleanMethodNameMustStartWithQuestion")
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, DaoUtils.LoadDescriptor loadDescriptor, T bean);
}
