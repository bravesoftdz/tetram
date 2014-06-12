package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.ConsistencyException;

/**
 * Created by Thierry on 30/05/2014.
 */
public interface DaoRW<T, PK> extends DaoRO<T, PK> {

    void validate(@NotNull T object) throws ConsistencyException;

    int save(@NotNull T transientObject) throws PersistenceException; //update an object of type T

    int delete(@NotNull PK id) throws PersistenceException;//delete an object of type T
}
