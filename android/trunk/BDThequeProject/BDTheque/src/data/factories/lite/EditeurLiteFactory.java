package org.tetram.bdtheque.data.factories.lite;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.factories.BeanFactory;
import org.tetram.bdtheque.data.lite.bean.EditeurLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class EditeurLiteFactory implements BeanFactory<EditeurLiteBean> {

    @Nullable
    @Override
    public EditeurLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        EditeurLiteBean bean = new EditeurLiteBean();
        if (!loadFromCursor(context, cursor, mustExists, bean)) return null;
        return bean;
    }

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, EditeurLiteBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.EDITEURS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setNom(getFieldString(cursor, DDLConstants.EDITEURS_NOM));
        return true;
    }

}
