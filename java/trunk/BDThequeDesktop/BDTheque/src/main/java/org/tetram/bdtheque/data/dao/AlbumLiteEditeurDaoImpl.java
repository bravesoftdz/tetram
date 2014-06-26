package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.dao.mappers.AlbumMapper;
import org.tetram.bdtheque.gui.utils.InitialEntity;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 23/06/2014.
 */
@Repository
@Lazy
@Transactional
@SuppressWarnings("UnusedDeclaration")
public class AlbumLiteEditeurDaoImpl extends DaoROImpl<AlbumLite, UUID> implements AlbumLiteEditeurDao {

    private static final String UNKNOWN_LABEL = I18nSupport.message("initiale.inconnu");
    @Autowired
    private AlbumMapper albumMapper;

    @Override
    public List<InitialEntity<UUID>> getListInitiales(String filtre) {
        return albumMapper.getInitialesEditeurs(filtre);
    }

    @Override
    public String getUnknownLabel() {
        return UNKNOWN_LABEL;
    }

    @Override
    public List<AlbumLite> getListEntitiesByInitiale(InitialEntity<UUID> initiale, String filtre) {
        return albumMapper.getAlbumLiteByEditeur(initiale.getValue(), filtre);
    }
}
