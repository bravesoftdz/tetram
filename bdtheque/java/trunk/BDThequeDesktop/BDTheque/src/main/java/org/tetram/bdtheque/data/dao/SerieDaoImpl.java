/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SerieDaoImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.*;
import org.tetram.bdtheque.data.dao.mappers.AuteurMapper;
import org.tetram.bdtheque.data.dao.mappers.GenreMapper;
import org.tetram.bdtheque.data.dao.mappers.SerieMapper;
import org.tetram.bdtheque.data.dao.mappers.UniversMapper;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.TypeUtils;

import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
@Repository
@Lazy
@Transactional
class SerieDaoImpl extends DaoScriptImpl<Serie, UUID> implements SerieDao, EvaluatedEntityDao<Serie> {

    @Autowired
    private SerieMapper serieMapper;
    @Autowired
    private GenreMapper genreMapper;
    @Autowired
    private AuteurMapper auteurMapper;
    @Autowired
    private UniversMapper universMapper;

    @Override
    public Serie get(UUID id) {
        if (id == null || id.equals(TypeUtils.GUID_NULL))
            return new Serie();
        else
            return super.get(id);
    }

    @Override
    public void validate(@NotNull Serie object) throws ConsistencyException {
        super.validate(object);
        if (StringUtils.isNullOrEmpty(object.getTitreSerie()))
            throw new ConsistencyException(I18nSupport.message("titre.obligatoire"));
        if (object.getEditeur() == null)
            throw new ConsistencyException(I18nSupport.message("editeur.obligatoire"));
    }

    @Override
    public int save(@NotNull Serie o) throws PersistenceException {
        int status = super.save(o);
        if (status == 0) return status;

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

    @Override
    public void changeNotation(Serie entity, ValeurListe notation) {
        serieMapper.changeNotation(entity.getId(), notation);
    }
}
