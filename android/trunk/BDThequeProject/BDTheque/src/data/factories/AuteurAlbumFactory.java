package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AuteurBean;
import org.tetram.bdtheque.data.bean.enums.AuteurMetier;
import org.tetram.bdtheque.data.factories.lite.PersonneLiteFactory;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;

public class AuteurAlbumFactory extends AuteurFactory {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, AuteurBean bean) {
        bean.setPersonne(new PersonneLiteFactory().loadFromCursor(context, cursor, false));
        if (bean.getPersonne() == null) return false;
        bean.setMetier(AuteurMetier.fromValue(getFieldAsInteger(cursor, DDLConstants.AUTEURS_METIER)));
        return true;
    }
}
