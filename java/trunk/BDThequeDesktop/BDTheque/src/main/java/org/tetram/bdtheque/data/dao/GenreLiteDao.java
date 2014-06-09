package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
public class GenreLiteDao extends AbstractDao<GenreLite, UUID> {

    //@Transactional(rollbackFor = ConsistencyException.class)
    @Override
    public int create(GenreLite o) throws ConsistencyException {
        if (!isUnique(o))
            throw new ConsistencyException(I18nSupport.message("title.still.used", I18nSupport.message("genre")));
        return super.create(o);

    }

    //@Transactional(rollbackFor = ConsistencyException.class)
    @Override
    public int update(GenreLite o) throws ConsistencyException {
        if (!isUnique(o))
            throw new ConsistencyException(I18nSupport.message("title.still.used", I18nSupport.message("genre")));
        return super.update(o);
    }
}
