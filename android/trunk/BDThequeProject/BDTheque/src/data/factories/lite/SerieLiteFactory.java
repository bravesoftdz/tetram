package org.tetram.bdtheque.data.factories.lite;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.factories.BeanFactoryImpl;
import org.tetram.bdtheque.data.utils.Notation;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public class SerieLiteFactory extends BeanFactoryImpl<SerieLiteBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, SerieLiteBean bean) {
        bean.setId(getFieldAsUUID(cursor, DDLConstants.SERIES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setTitre(getFieldAsString(cursor, DDLConstants.SERIES_TITRE));
        bean.setEditeur(new EditeurLiteFactory().loadFromCursor(context, cursor, false));
        bean.setCollection(new CollectionLiteFactory().loadFromCursor(context, cursor, false));
        bean.setNotation(Notation.fromValue(getFieldAsInteger(cursor, DDLConstants.SERIES_NOTATION)));
        return true;
    }

}
