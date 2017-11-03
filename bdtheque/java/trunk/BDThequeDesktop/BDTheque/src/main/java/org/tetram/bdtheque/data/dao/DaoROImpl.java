/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * DaoROImpl.java
 * Last modified by Tetram, on 2014-07-29T11:02:06CEST
 */
package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSessionFactory;
import org.jetbrains.annotations.NonNls;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.utils.GenericUtils;
import org.tetram.bdtheque.utils.logging.Log;
import org.tetram.bdtheque.utils.logging.LogManager;

/**
 * Created by Thierry on 11/06/2014.
 */
abstract class DaoROImpl<T extends AbstractDBEntity, PK> extends SqlSessionDaoSupport implements DaoRO<T, PK> {
    /**
     * Define prefixes for easier naming conventions between XML mappers files and the DAO class
     */
    @NonNls
    private static final String PREFIX_SELECT_QUERY = "get";     //prefix of select queries in mappers files (eg. getAddressType)
    private static Log log = LogManager.getLog(DaoRWImpl.class);
    protected final Class<T> type;

    @SuppressWarnings("unchecked")
    public DaoROImpl() {
        this.type = (Class<T>) GenericUtils.getTypeArguments(DaoROImpl.class, getClass()).get(0);
    }

    @SuppressWarnings("EmptyMethod")
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
        @NonNls String query = PREFIX_SELECT_QUERY + this.type.getSimpleName() + "ById";
        return getSqlSession().selectOne(query, id);
    }
}
