package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;
import org.tetram.bdtheque.data.bean.AlbumLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.*;

public class AlbumLiteFactory implements BeanFactory<AlbumLiteBean> {

    @Override
    public AlbumLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        AlbumLiteBean a = new AlbumLiteBean();
        a.setId(getFieldUUID(cursor, DDLConstants.ALBUMS_ID));
        if (mustExists && a.getId() == null) return null;
        a.setTitre(getFieldString(cursor, DDLConstants.ALBUMS_TITRE));
        a.setTome(getFieldInteger(cursor, DDLConstants.ALBUMS_TOME));
        a.setTomeDebut(getFieldInteger(cursor, DDLConstants.ALBUMS_TOMEDEBUT));
        a.setTomeFin(getFieldInteger(cursor, DDLConstants.ALBUMS_TOMEFIN));
        a.setHorsSerie(getFieldBoolean(cursor, DDLConstants.ALBUMS_HORSSERIE));
        a.setIntegrale(getFieldBoolean(cursor, DDLConstants.ALBUMS_INTEGRALE));
        a.setMoisParution(getFieldInteger(cursor, DDLConstants.ALBUMS_MOISPARUTION));
        a.setAnneeParution(getFieldInteger(cursor, DDLConstants.ALBUMS_ANNEEPARUTION));
        a.setNotation(getFieldInteger(cursor, DDLConstants.ALBUMS_NOTATION));
        a.setSerie(new SerieLiteFactory().loadFromCursor(context, cursor, false));
        a.setAchat(getFieldBoolean(cursor, DDLConstants.ALBUMS_ACHAT));
        a.setComplet(getFieldBoolean(cursor, DDLConstants.ALBUMS_COMPLET));
        return a;
    }

}
