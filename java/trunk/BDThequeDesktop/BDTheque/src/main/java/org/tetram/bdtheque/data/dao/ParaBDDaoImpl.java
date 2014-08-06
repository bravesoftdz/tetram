/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ParaBDDaoImpl.java
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
import org.tetram.bdtheque.data.bean.AuteurParaBDLite;
import org.tetram.bdtheque.data.bean.ParaBD;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.dao.mappers.AuteurMapper;
import org.tetram.bdtheque.data.dao.mappers.UniversMapper;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
@Transactional
class ParaBDDaoImpl extends DaoRWImpl<ParaBD, UUID> implements ParaBDDao {

    @Autowired
    AuteurMapper auteurMapper;
    @Autowired
    private UserPreferences userPreferences;
    @Autowired
    private UniversMapper universMapper;
    @Autowired
    private PhotoLiteDao photoLiteDao;

    @Override
    public void validate(@NotNull ParaBD object) throws ConsistencyException {
        super.validate(object);
        if (userPreferences.isSerieObligatoireParaBD() && object.getSerie() == null)
            throw new ConsistencyException(I18nSupport.message("serie.obligatoire"));
        if (StringUtils.isNullOrEmpty(object.getTitreParaBD()) && object.getSerie() == null)
            throw new ConsistencyException(I18nSupport.message("titre.obligatoire.parabd.sans.serie"));
        if (object.getCategorieParaBD() == null)
            throw new ConsistencyException(I18nSupport.message("type.parabd.obligatoire"));

        int anneeCote = object.getAnneeCote() == null ? 0 : object.getAnneeCote().getValue();
        double prixCote = object.getPrixCote() == null ? 0 : object.getPrixCote();
        if (anneeCote * prixCote == 0 && anneeCote + prixCote != 0)
            // une cote doit être composée d'une année ET d'un prix
            throw new ConsistencyException(I18nSupport.message("cote.incomplete"));
    }

    @Override
    public int save(@NotNull ParaBD o) throws PersistenceException {
        int status = super.save(o);

        auteurMapper.cleanAuteursParaBD(o.getId());
        for (AuteurParaBDLite auteur : o.getAuteurs())
            auteurMapper.addAuteurParaBD(o.getId(), auteur);

        universMapper.cleanUniversParaBD(o.getId(), o.getUnivers());
        for (UniversLite univers : o.getUnivers())
            universMapper.addUniversParaBD(o.getId(), univers.getId());

        photoLiteDao.saveList(o.getPhotos(), o.getId());
        return status;
    }
}
