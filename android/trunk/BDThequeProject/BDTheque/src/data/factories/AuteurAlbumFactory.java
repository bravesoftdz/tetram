package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AuteurBean;
import org.tetram.bdtheque.data.bean.AuteurMetier;
import org.tetram.bdtheque.data.factories.lite.PersonneLiteFactory;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public class AuteurAlbumFactory extends AuteurFactory {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, AuteurBean bean) {
        bean.setId(getFieldAsUUID(cursor, DDLConstants.AUTEURS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setPersonne(new PersonneLiteFactory().loadFromCursor(context, cursor, mustExists));
        if (bean.getPersonne() == null) return false;
        bean.setMetier(AuteurMetier.fromValue(getFieldAsInteger(cursor, DDLConstants.AUTEURS_METIER)));
        return true;
    }
}
