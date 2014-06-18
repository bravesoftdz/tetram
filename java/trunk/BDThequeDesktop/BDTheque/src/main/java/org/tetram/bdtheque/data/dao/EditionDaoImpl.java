package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Edition;
import org.tetram.bdtheque.utils.I18nSupport;

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

}
