package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.PersonneBean;
import org.tetram.bdtheque.database.DDLConstants;

import java.net.URL;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class PersonneFactory extends BeanFactoryImpl<PersonneBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, PersonneBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.PERSONNES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setNom(getFieldString(cursor, DDLConstants.PERSONNES_NOM));
        try {
            bean.setSiteWeb(new URL(getFieldString(cursor, DDLConstants.PERSONNES_SITEWEB)));
        } catch (Exception e) {
            e.printStackTrace();
            bean.setSiteWeb(null);
        }
        bean.setBiographie(getFieldString(cursor, DDLConstants.PERSONNES_BIOGRAPHIE));
        return true;
    }
}
