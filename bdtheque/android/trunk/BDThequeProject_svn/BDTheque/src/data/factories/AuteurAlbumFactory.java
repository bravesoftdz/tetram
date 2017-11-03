package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AuteurAlbumBean;
import org.tetram.bdtheque.data.bean.enums.AuteurMetier;
import org.tetram.bdtheque.data.factories.lite.PersonneLiteFactory;
import org.tetram.bdtheque.data.utils.DaoUtils;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;

public class AuteurAlbumFactory extends BeanFactoryImpl<AuteurAlbumBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, DaoUtils.LoadDescriptor loadDescriptor, AuteurAlbumBean bean) {
        bean.setPersonne(new PersonneLiteFactory().loadFromCursor(context, cursor, false, null));
        if (bean.getPersonne() == null) return false;
        bean.setMetier(AuteurMetier.fromValue(getFieldAsInteger(cursor, DDLConstants.AUTEURS_ALBUMS_METIER)));
        return true;
    }
}
