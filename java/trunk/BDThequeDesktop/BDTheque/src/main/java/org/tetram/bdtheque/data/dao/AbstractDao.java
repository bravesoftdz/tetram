package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.utils.GenericUtils;
import org.tetram.bdtheque.utils.logging.Log;
import org.tetram.bdtheque.utils.logging.LogManager;

/**
 * Created by Thierry on 30/05/2014.
 */
public class AbstractDao<T, PK> implements Dao<T, PK> {
    /**
     * Define prefixes for easier naming convetions between XML mappers files and the DAO class
     */
    public static final String PREFIX_SELECT_QUERY = "get";     //prefix of select queries in mappers files (eg. getAddressType)
    public static final String PREFIX_INSERT_QUERY = "create"; //prefix of create queries in mappers files (eg. createAddressType)
    public static final String PREFIX_UPDATE_QUERY = "update";  //prefix of update queries in mappers files (eg. updateAddressType)
    public static final String PREFIX_DELETE_QUERY = "delete";  //prefix of delete queries in mappers files (eg. deleteAddressType)
    private static Log log = LogManager.getLog(AbstractDao.class);
    private Class<T> type;

    /**
     * Default Constructor
     */
    @SuppressWarnings("unchecked")
    protected AbstractDao() {
        this.type = (Class<T>) GenericUtils.getTypeArguments(AbstractDao.class, getClass()).get(0);
    }

    /**
     * Default get by id method.
     * </br></br>
     * Almost all objects in the db will
     * need this (except mapping tables for multiple joins, which you
     * probably shouldn't even have as objects in your model, since proper
     * MyBatis mappings can take care of that).
     * </br></br>
     * Example:
     * </br>
     * If your DAO object is called CarInfo.java,
     * the corresponding mappers query id should be: &lt;select id="getCarInfo" ...
     */
    final public T get(PK id) throws PersistenceException {
        return get(id, null);
    }

    public T get(PK id, SqlSession session) throws PersistenceException {
        boolean sessionToClose = session == null;
        if (sessionToClose) session = Database.getInstance().openSession();
        try {
            String query = PREFIX_SELECT_QUERY + this.type.getSimpleName() + "ById";
            return session.selectOne(query, id);
        } finally {
            if (sessionToClose) session.close();
        }
    }

    /**
     * Method inserts the object into the table.
     * </br></br>
     * You will usually override this method, especially if you're inserting associated objects.
     * </br>
     * Example:
     * </br>
     * If your DAO object is called CarInfo.java,
     * the corresponding mappers query id should be: &lt;insert id="createCarInfo" ...
     * </br></br>
     * SQL Executed (example): insert into [tablename] (fieldname1,fieldname2,...) values(value1,value2...) ...
     */
    final public int create(T o) throws PersistenceException {
        return create(o, null);
    }

    public int create(T o, SqlSession session) throws PersistenceException {
        boolean sessionToClose = session == null;
        if (sessionToClose) session = Database.getInstance().openSession();
        try {
            String query = PREFIX_INSERT_QUERY + o.getClass().getSimpleName();
            Integer status = session.insert(query, o);
            session.commit();
            return status;
        } finally {
            if (sessionToClose) session.close();
        }
    }

    /**
     * Method updates the object by id.
     * </br></br>
     * You will usually override this method. But it can be used for simple objects.
     * </br>
     * Example:
     * </br>
     * If your DAO object is called CarInfo.java,
     * the corresponding mappers query id should be: &lt;update id="updateCarInfo" ...
     * </br></br>
     * SQL Executed (example): update [tablename] set fieldname1 = value1 where id = #{id}
     */
    final public int update(T o) throws PersistenceException {
        return update(o, null);
    }

    public int update(T o, SqlSession session) throws PersistenceException {
        boolean sessionToClose = session == null;
        if (sessionToClose) session = Database.getInstance().openSession();
        try {
            String query = PREFIX_UPDATE_QUERY + o.getClass().getSimpleName();
            Integer status = session.update(query, o);
            session.commit();
            return status;
        } finally {
            if (sessionToClose) session.close();
        }
    }

    /**
     * Method deletes the object by id.
     * </br></br>
     * Example:
     * </br>
     * If your DAO object is called CarInfo.java,
     * the corresponding mappers query id should be: &lt;delete id="deleteCarInfo" ...
     * </br></br>
     * SQL Executed (example): update [tablename] set fieldname1 = value1 where id = #{id}
     */
    final public int delete(PK id) throws PersistenceException {
        return delete(id, null);
    }

    public int delete(PK id, SqlSession session) throws PersistenceException {
        boolean sessionToClose = session == null;
        if (sessionToClose) session = Database.getInstance().openSession();
        try {
            String query = PREFIX_DELETE_QUERY + this.type.getSimpleName();
            Integer status = session.delete(query, id);
            session.commit();
            return status;
        } finally {
            if (sessionToClose) session.close();
        }
    }
}
