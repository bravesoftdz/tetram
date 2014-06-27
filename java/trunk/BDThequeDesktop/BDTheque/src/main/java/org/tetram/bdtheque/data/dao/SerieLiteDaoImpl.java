package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.SerieLite;
import org.tetram.bdtheque.data.dao.mappers.SerieMapper;
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
public class SerieLiteDaoImpl extends DaoROImpl<SerieLite, UUID> implements SerieLiteDao {

    @Autowired
    private SerieMapper serieMapper;

    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        return serieMapper.getInitiales(filtre);
    }

    @Override
    public List<SerieLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        return serieMapper.getSerieLiteByInitiale(initiale.getValue(), filtre);
    }
}
