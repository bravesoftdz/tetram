package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.GenreLite;

import java.util.UUID;

/**
 * Created by Thierry on 10/06/2014.
 */
public interface GenreLiteDao extends Dao<GenreLite, UUID> {
    @Override
    int create(GenreLite o) throws ConsistencyException;

    @Override
    int update(GenreLite o) throws ConsistencyException;
}
