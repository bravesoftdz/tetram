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
@SuppressWarnings("UnusedDeclaration")
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

        int l = object.getISBN() == null ? 0 : object.getISBN().length();
        if not(lISBN in[10, 13])
                l = (object.getAnneeEdition() == 0 || object.getAnneeEdition() >= 2007) ? 13 : 10;
        if not VerifieISBN(cs, lISBN) then
            if MessageDlg(Format(RemplacerValeur, [FormatISBN(EditionComplete.ISBN), FormatISBN(cs)]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin
                EditionComplete.ISBN := cs;
            end
        */
        int anneeCote = edition.getAnneeCote() == null ? 0 : edition.getAnneeCote();
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
        if (!TypeUtils.sameValue(source.getIdEditeur(), Edition.defaultEdition.getIdEditeur()) && !TypeUtils.sameValue(source.getIdEditeur(), dest.getIdEditeur()))
            dest.setEditeur(editeurDao.get(source.getIdEditeur()));
        if (!TypeUtils.sameValue(source.getIdCollection(), Edition.defaultEdition.getIdCollection()) && !TypeUtils.sameValue(source.getIdCollection(), dest.getIdCollection()))
            dest.setCollection(collectionDao.get(source.getIdCollection()));

        if (source.getTypeEdition() != Edition.defaultEdition.getTypeEdition())
            dest.setTypeEdition(source.getTypeEdition());
        if (source.getEtat() != Edition.defaultEdition.getEtat())
            dest.setEtat(source.getEtat());
        if (source.getReliure() != Edition.defaultEdition.getReliure())
            dest.setReliure(source.getReliure());
        if (source.getFormatEdition() != Edition.defaultEdition.getFormatEdition())
            dest.setFormatEdition(source.getFormatEdition());
        if (source.getOrientation() != Edition.defaultEdition.getOrientation())
            dest.setOrientation(source.getOrientation());
        if (source.getSensLecture() != Edition.defaultEdition.getSensLecture())
            dest.setSensLecture(source.getSensLecture());

        if (!TypeUtils.sameValue(source.getAnneeEdition(), Edition.defaultEdition.getAnneeEdition()))
            dest.setAnneeEdition(source.getAnneeEdition());
        if (!TypeUtils.sameValue(source.getNombreDePages(), Edition.defaultEdition.getNombreDePages()))
            dest.setNombreDePages(source.getNombreDePages());
        if (!TypeUtils.sameValue(source.getAnneeCote(), Edition.defaultEdition.getAnneeCote()))
            dest.setAnneeCote(source.getAnneeCote());
        if (!TypeUtils.sameValue(source.getPrix(), Edition.defaultEdition.getPrix()))
            dest.setPrix(source.getPrix());
        if (!TypeUtils.sameValue(source.getPrixCote(), Edition.defaultEdition.getPrixCote()))
            dest.setPrixCote(source.getPrixCote());
        if (source.isCouleur() != Edition.defaultEdition.isCouleur())
            dest.setCouleur(source.isCouleur());
        if (source.isVO() != Edition.defaultEdition.isVO())
            dest.setVO(source.isVO());
        if (source.isDedicace() != Edition.defaultEdition.isDedicace())
            dest.setDedicace(source.isDedicace());
        if (source.isStock() != Edition.defaultEdition.isStock())
            dest.setStock(source.isStock());
        if (source.isPrete() != Edition.defaultEdition.isPrete())
            dest.setPrete(source.isPrete());
        if (source.isOffert() != Edition.defaultEdition.isOffert())
            dest.setOffert(source.isOffert());
        if (source.isGratuit() != Edition.defaultEdition.isGratuit())
            dest.setGratuit(source.isGratuit());
        if (!TypeUtils.sameValue(source.getISBN(), Edition.defaultEdition.getISBN()))
            dest.setISBN(source.getISBN());
        if (!TypeUtils.sameValue(source.getDateAchat(), Edition.defaultEdition.getDateAchat()))
            dest.setDateAchat(source.getDateAchat());
        if (!TypeUtils.sameValue(source.getNotes(), Edition.defaultEdition.getNotes()))
            dest.setNotes(source.getNotes());
        if (!TypeUtils.sameValue(source.getNumeroPerso(), Edition.defaultEdition.getNumeroPerso()))
            dest.setNumeroPerso(source.getNumeroPerso());

        for (CouvertureLite couvertureLite : source.getCouvertures())
            dest.addCouverture(couvertureLite);
    }
}
