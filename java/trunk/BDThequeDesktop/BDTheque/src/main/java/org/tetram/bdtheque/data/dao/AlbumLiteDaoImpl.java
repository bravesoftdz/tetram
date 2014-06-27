package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.dao.mappers.AlbumMapper;
import org.tetram.bdtheque.gui.utils.InitialeEntity;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 23/06/2014.
 */
@Repository
@Lazy
@Transactional
@SuppressWarnings("UnusedDeclaration")
public class AlbumLiteDaoImpl extends DaoROImpl<AlbumLite, UUID> implements AlbumLiteInitialeDao {

    @Autowired
    private AlbumMapper albumMapper;

    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        return albumMapper.getInitiales(filtre);
    }

    @Override
    public List<AlbumLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        return albumMapper.getAlbumLiteByInitiale(initiale.getValue(), filtre);
    }
}
