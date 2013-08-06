package org.tetram.bdtheque.data.factories;

import android.database.Cursor;

import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.AuteurAlbumBean;
import org.tetram.bdtheque.data.dao.AuteurAlbumDao;
import org.tetram.bdtheque.data.dao.EditionDao;
import org.tetram.bdtheque.data.orm.LoadDescriptor;

import java.util.List;

public class AlbumFactory extends BeanFactoryImpl<AlbumBean> {
    @Override
    public boolean loadFromCursor(Cursor cursor, boolean inline, LoadDescriptor loadDescriptor, AlbumBean bean) {
        List<AuteurAlbumBean> auteurs = new AuteurAlbumDao().getAuteurs(bean);
        for (AuteurAlbumBean auteur : auteurs)
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

        new EditionDao().loadListForAlbum(bean.getEditions(), bean);

        return true;
    }
}
