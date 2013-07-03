package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.GenreBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class GenreFactory implements BeanFactory<GenreBean> {
    @Nullable
    @Override
    public GenreBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        GenreBean bean = new GenreBean();
        bean.setId(getFieldUUID(cursor, DDLConstants.GENRES_ID));
        if (mustExists && (bean.getId() == null)) return null;
        bean.setNom(getFieldString(cursor, DDLConstants.GENRES_NOM));
        return bean;
    }
}
