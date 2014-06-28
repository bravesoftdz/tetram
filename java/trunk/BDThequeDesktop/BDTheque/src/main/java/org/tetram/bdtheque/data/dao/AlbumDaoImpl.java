package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AuteurAlbumLite;
import org.tetram.bdtheque.data.bean.Edition;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.dao.mappers.AuteurMapper;
import org.tetram.bdtheque.data.dao.mappers.EditionMapper;
import org.tetram.bdtheque.data.dao.mappers.ImageMapper;
import org.tetram.bdtheque.data.dao.mappers.UniversMapper;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.TypeUtils;

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
    @Autowired
    private EditionMapper editionMapper;
    @Autowired
    private ImageMapper imageMapper;
    @Autowired
    private SerieDao serieDao;

    @Override
    public void validate(@NotNull Album object) throws ConsistencyException {
        super.validate(object);

        if (userPreferences.isSerieObligatoireAlbums() && object.getSerie() == null)
            throw new ConsistencyException(I18nSupport.message("serie.obligatoire"));

        if (StringUtils.isNullOrEmpty(object.getTitreAlbum()) && object.getSerie() == null)
            throw new ConsistencyException(I18nSupport.message("titre.obligatoire.album.sans.serie"));

/* ne devrait pas être utile puisque Month est une énumération
        if (object.getMoisParution() != null && !new Range<>(1, 12).contains(object.getMoisParution()))
            throw new ConsistencyException(I18nSupport.message("mois.parution.incorrect"));
         */

        // validate vérifierait qu'on a bien sélectionné un album... or en création, on ne connait pas encore l'idAlbum à ce moment là
        for (Edition edition : object.getEditions()) editionDao.validateFromAlbum(edition);
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

        editionMapper.cleanEditionsAlbum(o.getId(), o.getEditions());
        imageMapper.cleanCouverturesAlbum(o.getId(), o.getEditions());
        for (Edition edition : o.getEditions()) edition.setIdAlbum(o.getId());
        editionDao.save(o.getEditions());

        return status;
    }

    @Override
    public void fusionneInto(@NotNull Album source, @NotNull Album dest) {
        Album defaultAlbum = Album.getDefaultAlbum();

        if (!TypeUtils.sameValue(source.getTitreAlbum(), defaultAlbum.getTitreAlbum()))
            dest.setTitreAlbum(source.getTitreAlbum());
        if (!TypeUtils.sameValue(source.getMoisParution(), defaultAlbum.getMoisParution()))
            dest.setMoisParution(source.getMoisParution());
        if (!TypeUtils.sameValue(source.getAnneeParution(), defaultAlbum.getAnneeParution()))
            dest.setAnneeParution(source.getAnneeParution());
        if (!TypeUtils.sameValue(source.getTome(), defaultAlbum.getTome()))
            dest.setTome(source.getTome());
        if (!TypeUtils.sameValue(source.getTomeDebut(), defaultAlbum.getTomeDebut()))
            dest.setTomeDebut(source.getTomeDebut());
        if (!TypeUtils.sameValue(source.getTomeFin(), defaultAlbum.getTomeFin()))
            dest.setTomeFin(source.getTomeFin());
        if (source.isHorsSerie() != dest.isHorsSerie())
            dest.setHorsSerie(source.isHorsSerie());
        if (source.isIntegrale() != dest.isIntegrale())
            dest.setIntegrale(source.isIntegrale());

        for (AuteurAlbumLite auteurAlbumLite : source.getScenaristes())
            if (BeanUtils.notInList(auteurAlbumLite, dest.getScenaristes()))
                dest.addScenariste(auteurAlbumLite.getPersonne());
        for (AuteurAlbumLite auteurAlbumLite : source.getDessinateurs())
            if (BeanUtils.notInList(auteurAlbumLite, dest.getDessinateurs()))
                dest.addDessinateur(auteurAlbumLite.getPersonne());
        for (AuteurAlbumLite auteurAlbumLite : source.getColoristes())
            if (BeanUtils.notInList(auteurAlbumLite, dest.getColoristes()))
                dest.addColoriste(auteurAlbumLite.getPersonne());

        if (!TypeUtils.sameValue(source.getSujet(), defaultAlbum.getSujet()))
            dest.setSujet(source.getSujet());
        if (!TypeUtils.sameValue(source.getNotes(), defaultAlbum.getNotes()))
            dest.setNotes(source.getNotes());

        // Série
        if (!TypeUtils.sameValue(source.getIdSerie(), defaultAlbum.getIdSerie()) && !TypeUtils.sameValue(source.getIdSerie(), dest.getIdSerie()))
            dest.setSerie(serieDao.get(source.getIdSerie()));

        // Univers
        for (UniversLite universLite : source.getUnivers())
            dest.addUnivers(universLite);
/*
    if Source.FusionneEditions then
      TDaoEditionFull.FusionneInto(Source.Editions, Dest.Editions);
 */
    }

}
