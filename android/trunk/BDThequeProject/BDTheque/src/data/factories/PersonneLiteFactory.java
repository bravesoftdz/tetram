package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.lite.PersonneLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class PersonneLiteFactory implements BeanFactory<PersonneLiteBean> {

    @Nullable
    @Override
    public PersonneLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        final PersonneLiteBean bean = new PersonneLiteBean();
        if (loadFromCursor(context, cursor, mustExists, bean)) return bean;
        return null;
    }

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, PersonneLiteBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.PERSONNES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setNom(getFieldString(cursor, DDLConstants.PERSONNES_NOM));
        return true;
    }
}
