package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;

/**
 * Created by Thierry on 30/05/2014.
 */
public abstract class DaoRWImpl<T extends AbstractDBEntity, PK> extends DaoROImpl<T, PK> implements DaoRW<T, PK> {

    @NonNls
    private static final String PREFIX_INSERT_QUERY = "create"; //prefix of create queries in mappers files (eg. createAddressType)
    @NonNls
    private static final String PREFIX_UPDATE_QUERY = "update";  //prefix of update queries in mappers files (eg. updateAddressType)
    @NonNls
    private static final String PREFIX_DELETE_QUERY = "delete";  //prefix of delete queries in mappers files (eg. deleteAddressType)
    @NonNls
    private static final String PREFIX_CHECK_UNIQUE_QUERY = "checkUnique";  //prefix of check unique queries in mappers files (eg. checkUniqueAddressType)

    /**
     * Default Constructor
     */
    protected DaoRWImpl() {
        super();
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
    @SuppressWarnings("UnnecessaryLocalVariable")
    private int create(T o) throws PersistenceException {
        String query = PREFIX_INSERT_QUERY + this.type.getSimpleName();
        Integer status = getSqlSession().insert(query, o);
        // ne doit pas être utilisé avec une session Spring
        // getSqlSession().commit();
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
    @SuppressWarnings("UnnecessaryLocalVariable")
    private int update(T o) throws PersistenceException {
        String query = PREFIX_UPDATE_QUERY + this.type.getSimpleName();
        Integer status = getSqlSession().update(query, o);
        // ne doit pas être utilisé avec une session Spring
        // getSqlSession().commit();
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
    @SuppressWarnings("UnnecessaryLocalVariable")
    public int delete(@NotNull PK id) throws PersistenceException {
        String query = PREFIX_DELETE_QUERY + this.type.getSimpleName();
        Integer status = getSqlSession().delete(query, id);
        // ne doit pas être utilisé avec une session Spring
        // getSqlSession().commit();
        return status;
    }

    /**
     * Vérifie que l'objet est conforme à ses règles de gestion.</br>
     * Une exception est déclenchée dès qu'une erreur est détectée dans l'objet
     *
     * @param object objet à vérifier
     * @throws ConsistencyException
     */
    @Override
    public void validate(@NotNull T object) throws ConsistencyException {
    }

    @Override
    public int save(@NotNull T o) throws PersistenceException {
        validate(o);
        if (o.getId() == null)
            return create(o);
        else
            return update(o);
    }

    public boolean isUnique(T o) throws PersistenceException {
        String query = PREFIX_CHECK_UNIQUE_QUERY + this.type.getSimpleName();
        // on ne devrait jamais en trouver plus d'un mais par sécurité
        return getSqlSession().selectList(query, o).isEmpty();
    }
}
