package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.dao.ImageDao;
import org.tetram.bdtheque.data.orm.LoadDescriptor;

public class EditionFactory extends BeanFactoryImpl<EditionBean> {

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, LoadDescriptor loadDescriptor, EditionBean bean) {
        new ImageDao(context).loadListForEdition(bean.getImages(), bean);
        return true;
    }
}
