package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.AuteurBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.dao.AuteurDao;
import org.tetram.bdtheque.data.dao.GenreDao;
import org.tetram.bdtheque.data.factories.lite.CollectionLiteFactory;
import org.tetram.bdtheque.data.factories.lite.EditeurLiteFactory;
import org.tetram.bdtheque.database.DDLConstants;

import java.net.URL;
import java.util.List;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldUUID;

public class SerieFactory implements BeanFactory<SerieBean> {
    @Nullable
    @Override
    public SerieBean loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        SerieBean bean = new SerieBean();
        if (!loadFromCursor(context, cursor, mustExists, bean)) return null;
        return bean;
    }

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, SerieBean bean) {
        bean.setId(getFieldUUID(cursor, DDLConstants.SERIES_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setTitre(getFieldString(cursor, DDLConstants.SERIES_TITRE));
        bean.setEditeur(new EditeurLiteFactory().loadFromCursor(context, cursor, false));
        bean.setCollection(new CollectionLiteFactory().loadFromCursor(context, cursor, false));
        try {
            bean.setSiteWeb(new URL(getFieldString(cursor, DDLConstants.SERIES_SITEWEB)));
        } catch (Exception e) {
            e.printStackTrace();
            bean.setSiteWeb(null);
        }
        new GenreDao(context).loadListForSerie(bean.getGenres(), bean.getId());
        bean.setSujet(getFieldString(cursor, DDLConstants.SERIES_SUJET));
        bean.setNotes(getFieldString(cursor, DDLConstants.SERIES_NOTES));

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

        return true;
    }
}
