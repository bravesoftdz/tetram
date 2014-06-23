package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.SerieLite;

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
    @Override
    public List<org.tetram.bdtheque.gui.utils.InitialEntity> getListInitiales() {
        return null;
    }
}
