package org.tetram.bdtheque.data.factories.lite;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.factories.BeanFactoryImpl;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsBoolean;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public class AlbumLiteFactory extends BeanFactoryImpl<AlbumLiteBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, AlbumLiteBean bean) {
        bean.setId(getFieldAsUUID(cursor, DDLConstants.ALBUMS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setTitre(getFieldAsString(cursor, DDLConstants.ALBUMS_TITRE));
        bean.setTome(getFieldAsInteger(cursor, DDLConstants.ALBUMS_TOME));
        bean.setTomeDebut(getFieldAsInteger(cursor, DDLConstants.ALBUMS_TOMEDEBUT));
        bean.setTomeFin(getFieldAsInteger(cursor, DDLConstants.ALBUMS_TOMEFIN));
        bean.setHorsSerie(getFieldAsBoolean(cursor, DDLConstants.ALBUMS_HORSSERIE));
        bean.setIntegrale(getFieldAsBoolean(cursor, DDLConstants.ALBUMS_INTEGRALE));
        bean.setMoisParution(getFieldAsInteger(cursor, DDLConstants.ALBUMS_MOISPARUTION));
        bean.setAnneeParution(getFieldAsInteger(cursor, DDLConstants.ALBUMS_ANNEEPARUTION));
        bean.setNotation(getFieldAsInteger(cursor, DDLConstants.ALBUMS_NOTATION));
        bean.setSerie(new SerieLiteFactory().loadFromCursor(context, cursor, false));
        bean.setAchat(getFieldAsBoolean(cursor, DDLConstants.ALBUMS_ACHAT));
        bean.setComplet(getFieldAsBoolean(cursor, DDLConstants.ALBUMS_COMPLET));
        return true;
    }

}
