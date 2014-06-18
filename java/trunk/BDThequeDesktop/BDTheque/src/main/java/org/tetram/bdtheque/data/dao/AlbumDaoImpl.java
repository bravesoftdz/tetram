package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AuteurAlbumLite;
import org.tetram.bdtheque.data.bean.Edition;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.dao.mappers.AuteurMapper;
import org.tetram.bdtheque.data.dao.mappers.UniversMapper;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.Range;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
@Transactional
@SuppressWarnings("UnusedDeclaration")
public class AlbumDaoImpl extends DaoRWImpl<Album, UUID> implements AlbumDao {

    @Autowired
    AuteurMapper auteurMapper;
    @Autowired
    private UserPreferences userPreferences;
    @Autowired
    private UniversMapper universMapper;
    @Autowired
    private EditionDao editionDao;


    @Override
    public void validate(@NotNull Album object) throws ConsistencyException {
        super.validate(object);

        if (userPreferences.isSerieObligatoireAlbums() && object.getSerie() == null)
            throw new ConsistencyException(I18nSupport.message("serie.obligatoire"));

        if (StringUtils.isNullOrEmpty(object.getTitreAlbum()) && object.getSerie() == null)
            throw new ConsistencyException(I18nSupport.message("titre.obligatoire.album.sans.serie"));

        if (object.getMoisParution() != null && !new Range<>(1, 12).contains(object.getMoisParution()))
            throw new ConsistencyException(I18nSupport.message("mois.parution.incorrect"));

        for (Edition edition : object.getEditions())
            editionDao.validate(edition);
    }

    @Override
    public int save(@NotNull Album o) throws PersistenceException {
        int status = super.save(o);

        auteurMapper.cleanAuteursAlbum(o.getId());
        for (AuteurAlbumLite auteur : o.getAuteurs())
            auteurMapper.addAuteurAlbum(o.getId(), auteur);

        universMapper.cleanUniversAlbum(o.getId(), o.getUnivers());
        for (UniversLite univers : o.getUnivers())
            universMapper.addUniversAlbum(o.getId(), univers.getId());

        return status;
    }

}
