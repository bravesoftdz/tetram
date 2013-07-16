package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.ListeBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public class ListeFactory extends BeanFactoryImpl<ListeBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, ListeBean bean) {
        bean.setId(getFieldAsUUID(cursor, DDLConstants.LISTES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setRef(getFieldAsInteger(cursor, DDLConstants.LISTES_REF));
        bean.setCategorie(ListeBean.ListeCategorie.fromValue(getFieldAsInteger(cursor, DDLConstants.LISTES_CATEGORIE)));
        bean.setOrdre(getFieldAsInteger(cursor, DDLConstants.LISTES_ORDRE));
        bean.setDefaut(getFieldAsInteger(cursor, DDLConstants.LISTES_DEFAUT));
        bean.setLibelle(getFieldAsString(cursor, DDLConstants.LISTES_LIBELLE));
        return true;
    }
}
