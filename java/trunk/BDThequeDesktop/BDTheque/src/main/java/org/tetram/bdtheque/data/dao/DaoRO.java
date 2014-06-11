package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;

/**
 * Created by Thierry on 11/06/2014.
 */
public interface DaoRO<T, PK> {
    T get(PK id) throws PersistenceException;//get obj of type T by the primary key 'id'
}
