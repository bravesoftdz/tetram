package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.lite.AuteurLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class AuteurLiteFactory implements BeanFactory<AuteurLiteBean> {

    @Nullable
    @Override
    public AuteurLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        AuteurLiteBean bean = new AuteurLiteBean();
        bean.setId(getFieldUUID(cursor, DDLConstants.AUTEURS_ID));
        if (mustExists && (bean.getId() == null)) return null;
        bean.setNom(getFieldString(cursor, DDLConstants.AUTEURS_NOM));
        return bean;
    }

}
