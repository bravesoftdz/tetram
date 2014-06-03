package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.tetram.bdtheque.data.bean.Auteur;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.SerieLite;
import org.tetram.bdtheque.data.dao.mappers.AlbumMapper;
import org.tetram.bdtheque.data.dao.mappers.ParaBDMapper;
import org.tetram.bdtheque.data.dao.mappers.SerieMapper;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
@Configuration
public class AuteurDao extends AbstractDao<Auteur, UUID> {

    @Autowired
    private SerieMapper serieMapper;
    @Autowired
    private AlbumMapper albumMapper;
    @Autowired
    private ParaBDMapper paraBDMapper;
    @Autowired
    private SerieDao serieDao;

    @Override
    public Auteur get(UUID id) throws PersistenceException {
        Auteur auteur = super.get(id);
        if (auteur != null) {
            List<Serie> lst = new ArrayList<>();
            Serie serie;
            List<SerieLite> lstSerie = serieMapper.getListSerieIdByAuteurId(id);
            for (SerieLite serieLite : lstSerie) {
                if (serieLite == null || serieLite.getId() == null) {
                    serie = serieDao.get(null);
                    lst.add(0, serie);
                } else {
                    serie = serieDao.get(serieLite.getId());
                    lst.add(serie);
                }
                serie.setAlbums(albumMapper.getAlbumLiteBySerieIdByAuteurId(serie.getId(), id));
                serie.setParaBDs(paraBDMapper.getParaBDLiteBySerieIdByAuteurId(serie.getId(), id));
            }
            auteur.setSeries(lst);
        }
        return auteur;
    }
}
