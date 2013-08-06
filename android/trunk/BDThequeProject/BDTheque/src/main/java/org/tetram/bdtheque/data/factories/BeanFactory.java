package org.tetram.bdtheque.data.factories;

import android.database.Cursor;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.LoadDescriptor;

public interface BeanFactory<T extends CommonBean> {
    @SuppressWarnings("BooleanMethodNameMustStartWithQuestion")
    public boolean loadFromCursor(Cursor cursor, boolean inline, LoadDescriptor loadDescriptor, T bean);
}
