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

    private static final String UNKNOWN_LABEL = I18nSupport.message("initiale.inconnu");
    @Autowired
    private AlbumMapper albumMapper;

    @Override
    public List<InitialEntity> getListInitiales() {
        final List<InitialEntity> list = albumMapper.getInitialesSeries();
        for (InitialEntity initialEntity : list) {
            initialEntity.setUnknownLabel(UNKNOWN_LABEL);
            initialEntity.setValue(BeanUtils.formatTitre(initialEntity.getValue()));
        }
        return list;
    }
}
