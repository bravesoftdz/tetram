package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Auteur;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.SerieLite;
import org.tetram.bdtheque.data.dao.mappers.AlbumMapper;
import org.tetram.bdtheque.data.dao.mappers.ParaBDMapper;
import org.tetram.bdtheque.data.dao.mappers.SerieMapper;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
@Repository
@Lazy
@Transactional
public class AuteurDaoImpl extends DaoScriptImpl<Auteur, UUID> implements AuteurDao {

    @Autowired
    private SerieMapper serieMapper;
    @Autowired
    private AlbumMapper albumMapper;
    @Autowired
    private ParaBDMapper paraBDMapper;
    @Autowired
    private SerieDao serieDao;

    @Override
    public Auteur get(UUID id) {
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

    @Override
    public int save(@NotNull Auteur o) throws PersistenceException {
        if (!isUnique(o))
            throw new ConsistencyException(I18nSupport.message("title.still.used", I18nSupport.message("auteur")));
        return super.save(o);
    }

}
