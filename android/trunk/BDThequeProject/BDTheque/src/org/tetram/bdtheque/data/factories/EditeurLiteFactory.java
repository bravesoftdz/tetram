package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;
import org.tetram.bdtheque.data.bean.EditeurLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class EditeurLiteFactory implements BeanFactory<EditeurLiteBean> {

    @Override
    public EditeurLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        EditeurLiteBean e = new EditeurLiteBean();
        e.setId(getFieldUUID(cursor, DDLConstants.EDITEURS_ID));
        if (mustExists && e.getId() == null) return null;
        e.setNom(getFieldString(cursor, DDLConstants.EDITEURS_NOM));
        return e;
    }

}
