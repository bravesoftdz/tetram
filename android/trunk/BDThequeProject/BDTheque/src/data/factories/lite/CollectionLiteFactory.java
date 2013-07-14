package org.tetram.bdtheque.data.factories.lite;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.factories.BeanFactoryImpl;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public class CollectionLiteFactory extends BeanFactoryImpl<CollectionLiteBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, CollectionLiteBean bean) {
        bean.setId(getFieldAsUUID(cursor, DDLConstants.COLLECTIONS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setNom(getFieldAsString(cursor, DDLConstants.COLLECTIONS_NOM));
        return true;
    }

}
