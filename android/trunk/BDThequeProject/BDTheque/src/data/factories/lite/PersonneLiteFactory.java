package org.tetram.bdtheque.data.factories.lite;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.lite.PersonneLiteBean;
import org.tetram.bdtheque.data.factories.BeanFactoryImpl;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class PersonneLiteFactory extends BeanFactoryImpl<PersonneLiteBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, PersonneLiteBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.PERSONNES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setNom(getFieldString(cursor, DDLConstants.PERSONNES_NOM));
        return true;
    }
}
