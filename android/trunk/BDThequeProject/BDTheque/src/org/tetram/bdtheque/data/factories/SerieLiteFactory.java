package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;
import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.SerieLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class SerieLiteFactory implements BeanFactory<SerieLiteBean> {

    @Nullable
    @Override
    public SerieLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        SerieLiteBean bean = new SerieLiteBean();
        bean.setId(getFieldUUID(cursor, DDLConstants.SERIES_ID));
        if (mustExists && (bean.getId() == null)) return null;
        bean.setTitre(getFieldString(cursor, DDLConstants.SERIES_TITRE));
        bean.setEditeur(new EditeurLiteFactory().loadFromCursor(context, cursor, false));
        bean.setCollection(new CollectionLiteFactory().loadFromCursor(context, cursor, false));
        return bean;
    }

}
