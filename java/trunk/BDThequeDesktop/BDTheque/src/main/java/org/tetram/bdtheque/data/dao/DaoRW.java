package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.ConsistencyException;

import java.util.Collection;

/**
 * Created by Thierry on 30/05/2014.
 */
public interface DaoRW<T, PK> extends DaoRO<T, PK> {

    void validate(@NotNull T object) throws ConsistencyException;

    default void validate(@NotNull Collection<T> list) throws ConsistencyException {
        for (T o : list) validate(o);
    }

    int save(@NotNull T transientObject) throws PersistenceException; //update an object of type T

    default int save(@NotNull Collection<T> listTransientObject) throws PersistenceException {
        int result = 0;
        for (T o : listTransientObject) result += save(o);
        return result;
    } //update a list of object of type T

    int delete(@NotNull PK id) throws PersistenceException;//delete an object of type T

    default int delete(@NotNull Collection<PK> listId) throws PersistenceException {
        int result = 0;
        for (PK o : listId) result += delete(o);
        return result;
    } //delete a list of object of type T
}
