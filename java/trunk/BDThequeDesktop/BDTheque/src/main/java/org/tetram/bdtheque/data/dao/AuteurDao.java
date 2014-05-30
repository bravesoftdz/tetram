package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.Auteur;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.SerieLite;
import org.tetram.bdtheque.data.mappers.AlbumMapper;
import org.tetram.bdtheque.data.mappers.ParaBDMapper;
import org.tetram.bdtheque.data.mappers.SerieMapper;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
public class AuteurDao extends AbstractDao<Auteur, UUID> {

    @Override
    public Auteur get(UUID id, SqlSession session) throws PersistenceException {
        boolean sessionToClose = session == null;
        if (sessionToClose) session = Database.getInstance().openSession();
        try {
            Auteur auteur = super.get(id, session);
            if (auteur != null) {
                SerieDao serieDao = DaoFactory.getInstance().getDao(SerieDao.class);
                SerieMapper serieMapper = session.getMapper(SerieMapper.class);
                AlbumMapper albumMapper = session.getMapper(AlbumMapper.class);
                ParaBDMapper paraBDMapper = session.getMapper(ParaBDMapper.class);

                List<Serie> lst = new ArrayList<>();
                Serie serie;
                List<SerieLite> lstSerie = serieMapper.getListSerieIdByAuteurId(id);
                for (SerieLite serieLite : lstSerie) {
                    if (serieLite == null || serieLite.getId() == null) {
                        serie = serieDao.get(null, session);
                        lst.add(0, serie);
                    } else {
                        serie = serieDao.get(serieLite.getId(), session);
                        lst.add(serie);
                    }
                    serie.setAlbums(albumMapper.getAlbumLiteBySerieIdByAuteurId(serie.getId(), id));
                    serie.setParaBDs(paraBDMapper.getParaBDLiteBySerieIdByAuteurId(serie.getId(), id));
                }
                auteur.setSeries(lst);
            }
            return auteur;
        } finally {
            if (sessionToClose) session.close();
        }
    }
}
