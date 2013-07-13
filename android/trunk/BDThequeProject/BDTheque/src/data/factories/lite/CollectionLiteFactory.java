package org.tetram.bdtheque.data.factories.lite;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.factories.BeanFactoryImpl;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class CollectionLiteFactory extends BeanFactoryImpl<CollectionLiteBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, CollectionLiteBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.COLLECTIONS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setNom(getFieldString(cursor, DDLConstants.COLLECTIONS_NOM));
        return true;
    }

}
