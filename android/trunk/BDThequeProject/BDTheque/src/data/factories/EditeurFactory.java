package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.EditeurBean;
import org.tetram.bdtheque.database.DDLConstants;

import java.net.URL;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class EditeurFactory extends BeanFactoryImpl<EditeurBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, EditeurBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.EDITEURS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setNom(getFieldString(cursor, DDLConstants.EDITEURS_NOM));
        try {
            bean.setSiteWeb(new URL(getFieldString(cursor, DDLConstants.EDITEURS_SITEWEB)));
        } catch (Exception e) {
            e.printStackTrace();
            bean.setSiteWeb(null);
        }

        return true;
    }
}
