package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AuteurBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.dao.AuteurDao;
import org.tetram.bdtheque.data.dao.EditeurDao;
import org.tetram.bdtheque.data.dao.GenreDao;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteSerieDao;
import org.tetram.bdtheque.data.dao.lite.CollectionLiteDao;
import org.tetram.bdtheque.data.utils.Notation;
import org.tetram.bdtheque.database.DDLConstants;

import java.net.URL;
import java.util.List;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public class SerieFactory extends BeanFactoryImpl<SerieBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, SerieBean bean) {
        bean.setId(getFieldAsUUID(cursor, DDLConstants.SERIES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setTitre(getFieldAsString(cursor, DDLConstants.SERIES_TITRE));
        bean.setNotation(Notation.fromValue(getFieldAsInteger(cursor, DDLConstants.SERIES_NOTATION)));
        bean.setEditeur(new EditeurDao(context).getById(getFieldAsUUID(cursor, DDLConstants.EDITEURS_ID)));
        bean.setCollection(new CollectionLiteDao(context).getById(getFieldAsUUID(cursor, DDLConstants.COLLECTIONS_ID)));
        try {
            bean.setSiteWeb(new URL(getFieldAsString(cursor, DDLConstants.SERIES_SITEWEB)));
        } catch (Exception e) {
            e.printStackTrace();
            bean.setSiteWeb(null);
        }
        new GenreDao(context).loadListForSerie(bean.getGenres(), bean.getId());
        bean.setSujet(getFieldAsString(cursor, DDLConstants.SERIES_SUJET));
        bean.setNotes(getFieldAsString(cursor, DDLConstants.SERIES_NOTES));

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

        new AlbumLiteSerieDao(context).loadListForSerie(bean.getAlbums(), bean.getId());

        return true;
    }
}
