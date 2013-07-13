package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.dao.EditeurDao;
import org.tetram.bdtheque.data.dao.lite.CollectionLiteDao;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.UUID;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class EditionFactory extends BeanFactoryImpl<EditionBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, EditionBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.EDITIONS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setISBN(getFieldString(cursor, DDLConstants.EDITIONS_ISBN));
        final UUID editeurId = getFieldUUID(cursor, DDLConstants.EDITEURS_ID);
        if (editeurId != null) bean.setEditeur(new EditeurDao(context).getById(editeurId));
        final UUID collectionId = getFieldUUID(cursor, DDLConstants.COLLECTIONS_ID);
        if (collectionId != null)
            bean.setCollection(new CollectionLiteDao(context).getById(collectionId));

        return true;
    }
}
