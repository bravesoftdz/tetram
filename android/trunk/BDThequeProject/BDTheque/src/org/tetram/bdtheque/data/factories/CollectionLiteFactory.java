package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CollectionLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class CollectionLiteFactory implements BeanFactory<CollectionLiteBean> {

    @Nullable
    @Override
    public CollectionLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        CollectionLiteBean bean = new CollectionLiteBean();
        bean.setId(getFieldUUID(cursor, DDLConstants.AUTEURS_ID));
        if (mustExists && (bean.getId() == null)) return null;
        bean.setNom(getFieldString(cursor, DDLConstants.AUTEURS_NOM));
        return bean;
    }

}
