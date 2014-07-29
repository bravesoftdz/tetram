/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EditionDaoImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.CouvertureLite;
import org.tetram.bdtheque.data.bean.Edition;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.TypeUtils;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
@Transactional

public class EditionDaoImpl extends DaoRWImpl<Edition, UUID> implements EditionDao {

    @Autowired
    private CouvertureLiteDao couvertureLiteDao;
    @Autowired
    private EditeurDao editeurDao;
    @Autowired
    private CollectionDao collectionDao;

    @Override
    public void validateFromAlbum(@NotNull Edition edition) throws ConsistencyException {
        super.validate(edition);

        if (edition.getEditeur() == null)
            throw new ConsistencyException(I18nSupport.message("editeur.obligatoire"));
        /*
        ce n'est pas à faire par le DAO: il faut que l'utilisateur confirme la correction proposée

        int l = object.getIsbn() == null ? 0 : object.getIsbn().length();
        if not(lISBN in[10, 13])
                l = (object.getAnneeEdition() == 0 || object.getAnneeEdition() >= 2007) ? 13 : 10;
        if not VerifieISBN(cs, lISBN) then
            if MessageDlg(Format(RemplacerValeur, [FormatISBN(EditionComplete.ISBN), FormatISBN(cs)]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin
                EditionComplete.ISBN := cs;
            end
        */
        int anneeCote = edition.getAnneeCote() == null ? 0 : edition.getAnneeCote().getValue();
        double prixCote = edition.getPrixCote() == null ? 0 : edition.getPrixCote();
        if (anneeCote * prixCote == 0 && anneeCote + prixCote != 0)
            // une cote doit être composée d'une année ET d'un prix
            throw new ConsistencyException(I18nSupport.message("cote.incomplete"));
    }

    @Override
    public void validate(@NotNull Edition object) throws ConsistencyException {
        validateFromAlbum(object);
        if (object.getIdAlbum() == null)
            throw new ConsistencyException(I18nSupport.message("album.obligatoire"));
    }

    @Override
    public int save(@NotNull Edition o) throws PersistenceException {
        int status = super.save(o);
        @NonNls Map<String, UUID> params = new HashMap<>();
        params.put("idAlbum", o.getIdAlbum());
        couvertureLiteDao.saveList(o.getCouvertures(), o.getId(), params);
        return status;
    }

    @Override
    public void fusionneInto(@NotNull Edition source, @NotNull Edition dest) {
        Edition defaultEdition = Edition.getDefaultEdition();

        if (!TypeUtils.sameValue(source.getIdEditeur(), Edition.getDefaultEdition().getIdEditeur()) && !TypeUtils.sameValue(source.getIdEditeur(), dest.getIdEditeur()))
            dest.setEditeur(editeurDao.get(source.getIdEditeur()));
        if (!TypeUtils.sameValue(source.getIdCollection(), Edition.getDefaultEdition().getIdCollection()) && !TypeUtils.sameValue(source.getIdCollection(), dest.getIdCollection()))
            dest.setCollection(collectionDao.get(source.getIdCollection()));

        if (source.getTypeEdition() != defaultEdition.getTypeEdition())
            dest.setTypeEdition(source.getTypeEdition());
        if (source.getEtat() != defaultEdition.getEtat())
            dest.setEtat(source.getEtat());
        if (source.getReliure() != defaultEdition.getReliure())
            dest.setReliure(source.getReliure());
        if (source.getFormatEdition() != defaultEdition.getFormatEdition())
            dest.setFormatEdition(source.getFormatEdition());
        if (source.getOrientation() != defaultEdition.getOrientation())
            dest.setOrientation(source.getOrientation());
        if (source.getSensLecture() != defaultEdition.getSensLecture())
            dest.setSensLecture(source.getSensLecture());

        if (!TypeUtils.sameValue(source.getAnneeEdition(), defaultEdition.getAnneeEdition()))
            dest.setAnneeEdition(source.getAnneeEdition());
        if (!TypeUtils.sameValue(source.getNombreDePages(), defaultEdition.getNombreDePages()))
            dest.setNombreDePages(source.getNombreDePages());
        if (!TypeUtils.sameValue(source.getAnneeCote(), defaultEdition.getAnneeCote()))
            dest.setAnneeCote(source.getAnneeCote());
        if (!TypeUtils.sameValue(source.getPrix(), defaultEdition.getPrix()))
            dest.setPrix(source.getPrix());
        if (!TypeUtils.sameValue(source.getPrixCote(), defaultEdition.getPrixCote()))
            dest.setPrixCote(source.getPrixCote());
        if (source.isCouleur() != defaultEdition.isCouleur())
            dest.setCouleur(source.isCouleur());
        if (source.isVo() != defaultEdition.isVo())
            dest.setVo(source.isVo());
        if (source.isDedicace() != defaultEdition.isDedicace())
            dest.setDedicace(source.isDedicace());
        if (source.isStock() != defaultEdition.isStock())
            dest.setStock(source.isStock());
        if (source.isPrete() != defaultEdition.isPrete())
            dest.setPrete(source.isPrete());
        if (source.isOffert() != defaultEdition.isOffert())
            dest.setOffert(source.isOffert());
        if (source.isGratuit() != defaultEdition.isGratuit())
            dest.setGratuit(source.isGratuit());
        if (!TypeUtils.sameValue(source.getIsbn(), defaultEdition.getIsbn()))
            dest.setIsbn(source.getIsbn());
        if (!TypeUtils.sameValue(source.getDateAchat(), defaultEdition.getDateAchat()))
            dest.setDateAchat(source.getDateAchat());
        if (!TypeUtils.sameValue(source.getNotes(), defaultEdition.getNotes()))
            dest.setNotes(source.getNotes());
        if (!TypeUtils.sameValue(source.getNumeroPerso(), defaultEdition.getNumeroPerso()))
            dest.setNumeroPerso(source.getNumeroPerso());

        for (CouvertureLite couvertureLite : source.getCouvertures())
            dest.addCouverture(couvertureLite);
    }
}
