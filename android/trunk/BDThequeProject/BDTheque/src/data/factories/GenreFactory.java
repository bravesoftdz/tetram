package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.GenreBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public class GenreFactory extends BeanFactoryImpl<GenreBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, GenreBean bean) {
        bean.setId(getFieldAsUUID(cursor, DDLConstants.GENRES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setNom(getFieldAsString(cursor, DDLConstants.GENRES_NOM));
        return true;
    }
}
