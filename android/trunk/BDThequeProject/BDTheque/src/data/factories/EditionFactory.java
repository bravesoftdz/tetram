package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.dao.EditeurDao;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.UUID;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class EditionFactory implements BeanFactory<EditionBean> {
    @Nullable
    @Override
    public EditionBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        EditionBean bean = new EditionBean();
        if (!loadFromCursor(context, cursor, mustExists, bean)) return null;
        return bean;
    }

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, EditionBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.EDITIONS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setISBN(getFieldString(cursor, DDLConstants.EDITIONS_ISBN));

        final UUID editeurId = getFieldUUID(cursor, DDLConstants.EDITEURS_ID);
        if (editeurId != null) bean.setEditeur(new EditeurDao(context).getById(editeurId));

        return true;
    }
}
