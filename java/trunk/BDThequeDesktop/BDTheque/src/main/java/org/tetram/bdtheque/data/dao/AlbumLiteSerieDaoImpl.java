package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.dao.mappers.AlbumMapper;
import org.tetram.bdtheque.gui.utils.InitialeEntity;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 23/06/2014.
 */
@Repository
@Lazy
@Transactional
@SuppressWarnings("UnusedDeclaration")
public class AlbumLiteSerieDaoImpl extends DaoROImpl<AlbumLite, UUID> implements AlbumLiteSerieDao {

    private static final String UNKNOWN_LABEL = I18nSupport.message("initiale.inconnu.serie");
    @Autowired
    private AlbumMapper albumMapper;

    @SuppressWarnings("unchecked")
    @Override
    public List<InitialeEntity<UUID>> getListInitiales(String filtre) {
        return albumMapper.getInitialesSeries(filtre);
    }

    @Override
    public String getUnknownLabel() {
        return UNKNOWN_LABEL;
    }

    @Override
    public List<AlbumLite> getListEntitiesByInitiale(InitialeEntity<UUID> initiale, String filtre) {
        return albumMapper.getAlbumLiteBySerie(initiale.getValue(), filtre);
    }
}
