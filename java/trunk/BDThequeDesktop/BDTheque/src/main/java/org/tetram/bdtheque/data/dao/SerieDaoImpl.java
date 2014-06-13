package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.AuteurSerieLite;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.dao.mappers.AuteurMapper;
import org.tetram.bdtheque.data.dao.mappers.GenreMapper;
import org.tetram.bdtheque.data.dao.mappers.UniversMapper;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
@Repository
@Lazy
@Transactional
public class SerieDaoImpl extends DaoScriptImpl<Serie, UUID> implements SerieDao {

    @Autowired
    GenreMapper genreMapper;
    @Autowired
    AuteurMapper auteurMapper;
    @Autowired
    UniversMapper universMapper;

    @Override
    public Serie get(UUID id) {
        if (id == null || id.equals(StringUtils.GUID_NULL))
            return new Serie();
        else
            return super.get(id);
    }

    @Override
    public void validate(@NotNull Serie object) throws ConsistencyException {
        super.validate(object);
        if (object.getTitreSerie() == null || object.getTitreSerie().isEmpty())
            throw new ConsistencyException(I18nSupport.message("titre.obligatoire"));
        if (object.getEditeur() == null)
            throw new ConsistencyException(I18nSupport.message("editeur.obligatoire"));
    }

    @Override
    public int save(@NotNull Serie o) throws PersistenceException {
        int status = super.save(o);
        if (status == 0) return status;

        SqlSession session = getSqlSession();

        genreMapper.cleanGenresSerie(o.getId());
        for (GenreLite genre : o.getGenres())
            genreMapper.addGenreSerie(o.getId(), genre.getId());

        auteurMapper.cleanAuteursSerie(o.getId());
        for (AuteurSerieLite auteur : o.getAuteurs())
            auteurMapper.addAuteurSerie(o.getId(), auteur);

        universMapper.cleanUniversSerie(o.getId(), o.getUnivers());
        for (UniversLite univers : o.getUnivers())
            universMapper.addUniversSerie(o.getId(), univers.getId());

        return status;
    }
}
