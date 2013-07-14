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

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsBoolean;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public class AlbumFactory extends BeanFactoryImpl<AlbumBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, AlbumBean bean) {
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
        final UUID serieId = getFieldAsUUID(cursor, DDLConstants.SERIES_ID);
        if (serieId != null) bean.setSerie(new SerieDao(context).getById(serieId));
        bean.setAchat(getFieldAsBoolean(cursor, DDLConstants.ALBUMS_ACHAT));
        bean.setComplet(getFieldAsBoolean(cursor, DDLConstants.ALBUMS_COMPLET));
        bean.setSujet(getFieldAsString(cursor, DDLConstants.ALBUMS_SUJET));
        bean.setNotes(getFieldAsString(cursor, DDLConstants.ALBUMS_NOTES));

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
