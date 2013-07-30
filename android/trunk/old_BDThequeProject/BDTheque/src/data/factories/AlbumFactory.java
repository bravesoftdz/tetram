package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.AuteurBean;
import org.tetram.bdtheque.data.dao.AuteurDao;
import org.tetram.bdtheque.data.dao.EditionDao;

import java.util.List;

public class AlbumFactory extends BeanFactoryImpl<AlbumBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, AlbumBean bean) {
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
