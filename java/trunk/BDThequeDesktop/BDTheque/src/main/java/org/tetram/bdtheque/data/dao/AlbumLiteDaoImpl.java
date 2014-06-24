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
public class AlbumLiteDaoImpl extends DaoROImpl<AlbumLite, UUID> implements AlbumLiteDao {

    private static final String UNKNOWN_LABEL = I18nSupport.message("initiale.sans.serie");
    @Autowired
    private AlbumMapper albumMapper;

    @Override
    public List<InitialEntity> getListInitiales(String filtre) {
        final List<InitialEntity> list = albumMapper.getInitialesSeries(filtre);
        for (InitialEntity initialEntity : list) {
            if (initialEntity.getValue() == null)
                initialEntity.setLabel(UNKNOWN_LABEL);
            initialEntity.setLabel(BeanUtils.formatTitre(initialEntity.getLabel()));
        }
        return list;
    }

    @Override
    public List<AlbumLite> getListEntitiesByInitiale(String initiale, String filtre) {
        return albumMapper.getAlbumLiteBySerieId(StringUtils.GUIDStringToUUID(initiale), filtre);
    }
}
