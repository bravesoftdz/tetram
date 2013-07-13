package org.tetram.bdtheque.data.factories.lite;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.factories.BeanFactoryImpl;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class SerieLiteFactory extends BeanFactoryImpl<SerieLiteBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, SerieLiteBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.SERIES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setTitre(getFieldString(cursor, DDLConstants.SERIES_TITRE));
        bean.setEditeur(new EditeurLiteFactory().loadFromCursor(context, cursor, false));
        bean.setCollection(new CollectionLiteFactory().loadFromCursor(context, cursor, false));
        return true;
    }

}
