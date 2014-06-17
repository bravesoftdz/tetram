package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.Album;
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
    @Override
    public void validate(@NotNull Album object) throws ConsistencyException {
        super.validate(object);
        /*
        if TGlobalVar.Utilisateur.Options.SerieObligatoireAlbums and IsEqualGUID(vtEditSerie.CurrentValue, GUID_NULL) then
                begin
        AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
        vtEditSerie.SetFocus;
        ModalResult := mrNone;
        Exit;
        end;
        */
        if (StringUtils.isNullOrEmpty(object.getTitreAlbum()) && object.getSerie() == null)
            throw new ConsistencyException(I18nSupport.message("titre.obligatoire.album.sans.serie"));

        if (object.getMoisParution() != null && !new Range<>(1, 12).contains(object.getMoisParution()))
            throw new ConsistencyException(I18nSupport.message("mois.parution.incorrect"));
    }
}
