package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AuteurBean;
import org.tetram.bdtheque.data.bean.AuteurMetier;
import org.tetram.bdtheque.data.factories.lite.PersonneLiteFactory;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;

public class AuteurSerieFactory extends AuteurFactory {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, AuteurBean bean) {
        bean.setPersonne(new PersonneLiteFactory().loadFromCursor(context, cursor));
        if (bean.getPersonne() == null) return false;
        bean.setMetier(AuteurMetier.fromValue(getFieldAsInteger(cursor, DDLConstants.AUTEURS_SERIES_METIER)));
        return true;
    }
}
