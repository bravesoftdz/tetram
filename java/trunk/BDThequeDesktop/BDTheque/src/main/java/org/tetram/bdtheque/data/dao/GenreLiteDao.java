package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.GenreLite;

import java.util.UUID;

/**
 * Created by Thierry on 10/06/2014.
 */
public interface GenreLiteDao extends DaoRW<GenreLite, UUID>, RepertoireLiteDao<GenreLite, Character> {
    @Override
    int save(@NotNull GenreLite o) throws ConsistencyException;
}
