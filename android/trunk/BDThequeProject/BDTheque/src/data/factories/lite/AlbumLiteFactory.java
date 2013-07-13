package org.tetram.bdtheque.data.factories.lite;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.factories.BeanFactoryImpl;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldBoolean;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class AlbumLiteFactory extends BeanFactoryImpl<AlbumLiteBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, AlbumLiteBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.ALBUMS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setTitre(getFieldString(cursor, DDLConstants.ALBUMS_TITRE));
        bean.setTome(getFieldInteger(cursor, DDLConstants.ALBUMS_TOME));
        bean.setTomeDebut(getFieldInteger(cursor, DDLConstants.ALBUMS_TOMEDEBUT));
        bean.setTomeFin(getFieldInteger(cursor, DDLConstants.ALBUMS_TOMEFIN));
        bean.setHorsSerie(getFieldBoolean(cursor, DDLConstants.ALBUMS_HORSSERIE));
        bean.setIntegrale(getFieldBoolean(cursor, DDLConstants.ALBUMS_INTEGRALE));
        bean.setMoisParution(getFieldInteger(cursor, DDLConstants.ALBUMS_MOISPARUTION));
        bean.setAnneeParution(getFieldInteger(cursor, DDLConstants.ALBUMS_ANNEEPARUTION));
        bean.setNotation(getFieldInteger(cursor, DDLConstants.ALBUMS_NOTATION));
        bean.setSerie(new SerieLiteFactory().loadFromCursor(context, cursor, false));
        bean.setAchat(getFieldBoolean(cursor, DDLConstants.ALBUMS_ACHAT));
        bean.setComplet(getFieldBoolean(cursor, DDLConstants.ALBUMS_COMPLET));
        return true;
    }

}
