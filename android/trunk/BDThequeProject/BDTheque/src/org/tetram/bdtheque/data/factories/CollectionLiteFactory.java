package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;
import org.tetram.bdtheque.data.bean.CollectionLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class CollectionLiteFactory implements BeanFactory<CollectionLiteBean> {

    @Override
    public CollectionLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        CollectionLiteBean c = new CollectionLiteBean();
        c.setId(getFieldUUID(cursor, DDLConstants.AUTEURS_ID));
        if (mustExists && c.getId() == null) return null;
        c.setNom(getFieldString(cursor, DDLConstants.AUTEURS_NOM));
        return c;
    }

}
