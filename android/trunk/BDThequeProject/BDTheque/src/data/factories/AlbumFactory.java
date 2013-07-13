package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.AuteurBean;
import org.tetram.bdtheque.data.dao.AuteurDao;
import org.tetram.bdtheque.data.dao.EditionDao;
import org.tetram.bdtheque.data.dao.SerieDao;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.List;
import java.util.UUID;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldBoolean;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class AlbumFactory extends BeanFactoryImpl<AlbumBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, AlbumBean bean) {
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
        final UUID serieId = getFieldUUID(cursor, DDLConstants.SERIES_ID);
        if (serieId != null) bean.setSerie(new SerieDao(context).getById(serieId));
        bean.setAchat(getFieldBoolean(cursor, DDLConstants.ALBUMS_ACHAT));
        bean.setComplet(getFieldBoolean(cursor, DDLConstants.ALBUMS_COMPLET));
        bean.setSujet(getFieldString(cursor, DDLConstants.ALBUMS_SUJET));
        bean.setNotes(getFieldString(cursor, DDLConstants.ALBUMS_NOTES));

        List<AuteurBean> auteurs = new AuteurDao(context).getAuteurs(bean);
        for (AuteurBean auteur : auteurs)
            switch (auteur.getMetier()) {
                case SCENARISTE:
                    bean.getScenaristes().add(auteur);
                    break;
                case DESSINATEUR:
                    bean.getDessinateurs().add(auteur);
                    break;
                case COLORISTE:
                    bean.getColoristes().add(auteur);
                    break;
            }

        new EditionDao(context).loadListForAlbum(bean.getEditions(), bean.getId());

        return true;
    }
}
