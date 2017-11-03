package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AuteurSerieBean;
import org.tetram.bdtheque.data.bean.enums.AuteurMetier;
import org.tetram.bdtheque.data.dao.CommonDaoImpl;
import org.tetram.bdtheque.data.factories.lite.PersonneLiteFactory;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;

public class AuteurSerieFactory extends BeanFactoryImpl<AuteurSerieBean> {

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, CommonDaoImpl.LoadDescriptor loadDescriptor, AuteurSerieBean bean) {
        bean.setPersonne(new PersonneLiteFactory().loadFromCursor(context, cursor, false, null));
        if (bean.getPersonne() == null) return false;
        bean.setMetier(AuteurMetier.fromValue(getFieldAsInteger(cursor, DDLConstants.AUTEURS_SERIES_METIER)));
        return true;
    }
}
