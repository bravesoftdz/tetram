package org.tetram.bdtheque.data.factories;

import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AuteurSerieBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.dao.AuteurSerieDao;
import org.tetram.bdtheque.data.dao.GenreSerieDao;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteSerieDao;
import org.tetram.bdtheque.data.orm.LoadDescriptor;

import java.util.List;

public class SerieFactory extends BeanFactoryImpl<SerieBean> {
    @Override
    public boolean loadFromCursor(Cursor cursor, boolean inline, LoadDescriptor loadDescriptor, SerieBean bean) {
        new GenreSerieDao().loadListForSerie(bean.getGenres(), bean);

        List<AuteurSerieBean> auteurs = new AuteurSerieDao().getAuteurs(bean);
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

        new AlbumLiteSerieDao().loadListForSerie(bean.getAlbums(), bean.getId());

        return true;
    }
}
