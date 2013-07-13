package org.tetram.bdtheque.data.factories.lite;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.factories.BeanFactory;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class CollectionLiteFactory implements BeanFactory<CollectionLiteBean> {

    @Nullable
    @Override
    public CollectionLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        CollectionLiteBean bean = new CollectionLiteBean();
        if (!loadFromCursor(context, cursor, mustExists, bean)) return null;
        return bean;
    }

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, CollectionLiteBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.PERSONNES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setNom(getFieldString(cursor, DDLConstants.PERSONNES_NOM));
        return true;
    }

}
