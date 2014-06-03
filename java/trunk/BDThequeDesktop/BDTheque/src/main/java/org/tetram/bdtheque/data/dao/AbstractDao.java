package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.tetram.bdtheque.utils.GenericUtils;
import org.tetram.bdtheque.utils.logging.Log;
import org.tetram.bdtheque.utils.logging.LogManager;

/**
 * Created by Thierry on 30/05/2014.
 */
@Configuration
public class AbstractDao<T, PK> extends SqlSessionDaoSupport implements Dao<T, PK> {

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

    @Autowired
    @Override
    public void setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
        super.setSqlSessionFactory(sqlSessionFactory);
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
    public T get(PK id) throws PersistenceException {
        SqlSession session = getSqlSession();
        String query = PREFIX_SELECT_QUERY + this.type.getSimpleName() + "ById";
        return session.selectOne(query, id);
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
    public int create(T o) throws PersistenceException {
        String query = PREFIX_INSERT_QUERY + o.getClass().getSimpleName();
        Integer status = getSqlSession().insert(query, o);
        getSqlSession().commit();
        return status;
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
    public int update(T o) throws PersistenceException {
        String query = PREFIX_UPDATE_QUERY + o.getClass().getSimpleName();
        Integer status = getSqlSession().update(query, o);
        getSqlSession().commit();
        return status;
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
    public int delete(PK id) throws PersistenceException {
        String query = PREFIX_DELETE_QUERY + this.type.getSimpleName();
        Integer status = getSqlSession().delete(query, id);
        getSqlSession().commit();
        return status;
    }
}
