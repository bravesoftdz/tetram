package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Personne;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.SerieLite;
import org.tetram.bdtheque.data.dao.mappers.AlbumMapper;
import org.tetram.bdtheque.data.dao.mappers.ParaBDMapper;
import org.tetram.bdtheque.data.dao.mappers.SerieMapper;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
@Repository
@Lazy
@Transactional
@SuppressWarnings("UnusedDeclaration")
public class PersonneDaoImpl extends DaoScriptImpl<Personne, UUID> implements PersonneDao {

    @Autowired
    private SerieMapper serieMapper;
    @Autowired
    private AlbumMapper albumMapper;
    @Autowired
    private ParaBDMapper paraBDMapper;
    @Autowired
    private SerieDao serieDao;

    @Override
    public Personne get(UUID id) {
        Personne personne = super.get(id);
        if (personne != null) {
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
            personne.setSeries(lst);
        }
        return personne;
    }

    @Override
    public void validate(@NotNull Personne object) throws ConsistencyException {
        super.validate(object);
        if (StringUtils.isNullOrEmpty(object.getNomPersonne()))
            throw new ConsistencyException(I18nSupport.message("nom.obligatoire"));
    }

    @Override
    public int save(@NotNull Personne o) throws PersistenceException {
        if (!isUnique(o))
            throw new ConsistencyException(I18nSupport.message("title.still.used", I18nSupport.message("auteur")));
        return super.save(o);
    }

}
