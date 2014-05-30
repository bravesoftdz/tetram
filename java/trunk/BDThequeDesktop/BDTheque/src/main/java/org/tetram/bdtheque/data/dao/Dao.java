package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

/**
 * Created by Thierry on 30/05/2014.
 */
public interface Dao<T, PK> {
    public T get(PK id) throws PersistenceException;//get obj of type T by the primary key 'id'

    public T get(PK id, SqlSession session) throws PersistenceException;//get obj of type T by the primary key 'id'

    public int create(T objInstance) throws PersistenceException;//insert an object of type T into the database

    public int create(T objInstance, SqlSession session) throws PersistenceException;//insert an object of type T into the database

    int update(T transientObject) throws PersistenceException; //update an object of type T

    int update(T transientObject, SqlSession session) throws PersistenceException; //update an object of type T

    int delete(PK id) throws PersistenceException;//delete an object of type T

    int delete(PK id, SqlSession session) throws PersistenceException;//delete an object of type T
}
