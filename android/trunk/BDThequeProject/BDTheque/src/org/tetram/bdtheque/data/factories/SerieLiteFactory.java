package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;
import org.tetram.bdtheque.data.bean.SerieLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class SerieLiteFactory implements BeanFactory<SerieLiteBean> {

    @Override
    public SerieLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        SerieLiteBean s = new SerieLiteBean();
        s.setId(getFieldUUID(cursor, DDLConstants.SERIES_ID));
        if (mustExists && s.getId() == null) return null;
        s.setTitre(getFieldString(cursor, DDLConstants.SERIES_TITRE));
        s.setEditeur(new EditeurLiteFactory().loadFromCursor(context, cursor, false));
        s.setCollection(new CollectionLiteFactory().loadFromCursor(context, cursor, false));
        return s;
    }

}
