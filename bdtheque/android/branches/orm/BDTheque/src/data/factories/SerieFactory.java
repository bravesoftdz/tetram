package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AuteurSerieBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.dao.AuteurSerieDao;
import org.tetram.bdtheque.data.dao.CommonDaoImpl;
import org.tetram.bdtheque.data.dao.GenreDao;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteSerieDao;

import java.util.List;

public class SerieFactory extends BeanFactoryImpl<SerieBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, CommonDaoImpl.LoadDescriptor loadDescriptor, SerieBean bean) {
        new GenreDao(context).loadListForSerie(bean.getGenres(), bean.getId());

        List<AuteurSerieBean> auteurs = new AuteurSerieDao(context).getAuteurs(bean);
        for (AuteurSerieBean auteur : auteurs)
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
