package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;

/**
 * Created by Thierry on 30/05/2014.
 */
public interface DaoRW<T, PK> extends DaoRO<T,PK> {

    int save(T transientObject) throws PersistenceException; //update an object of type T

    int delete(PK id) throws PersistenceException;//delete an object of type T
}
