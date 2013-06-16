package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;
import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.AlbumLiteBean;
import org.tetram.bdtheque.database.DDLConstants;

import static org.tetram.bdtheque.data.utils.DaoUtils.*;

public class AlbumLiteFactory implements BeanFactory<AlbumLiteBean> {

    @Nullable
    @Override
    public AlbumLiteBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        AlbumLiteBean bean = new AlbumLiteBean();
        bean.setId(getFieldUUID(cursor, DDLConstants.ALBUMS_ID));
        if (mustExists && (bean.getId() == null)) return null;
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
        return bean;
    }

}
