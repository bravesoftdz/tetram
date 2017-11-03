/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * DaoScriptImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.mappers.CommonMapper;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.TypeUtils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.UUID;

/**
 * Created by Thierry on 12/06/2014.
 */
abstract class DaoScriptImpl<T extends AbstractDBEntity & ScriptEntity, PK> extends DaoRWImpl<T, PK> implements DaoScript<T> {

    @Autowired
    private CommonMapper commonMapper;

    @Override
    public int save(@NotNull T o) throws PersistenceException {
        int status = super.save(o);
        saveAssociations(o);
        return status;
    }

    @Override
    public T get(PK id) throws PersistenceException {
        T o = super.get(id);
        if (o != null)
            fillAssociations(o);
        return o;
    }

    @SuppressWarnings("HardCodedStringLiteral")
    @Override
    public void fillAssociations(@NotNull T entity) {
        ScriptInfo annotation = type.getAnnotation(ScriptInfo.class);
        assert annotation != null;

        entity.setAssociations(commonMapper.fillAssociations(entity.getId(), annotation.typeData()));
    }

    @SuppressWarnings("CallToStringEquals")
    @Override
    public void saveAssociations(@NotNull T entity) {
        ScriptInfo annotation = type.getAnnotation(ScriptInfo.class);
        assert annotation != null;

        UUID parentId = TypeUtils.GUID_NULL;
        if (!annotation.getParentIdMethod().isEmpty()) {
            try {
                Method method = type.getMethod(annotation.getParentIdMethod());
                assert method != null;
                parentId = (UUID) method.invoke(entity);
            } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
                e.printStackTrace();
            }
        }

        commonMapper.cleanAssociations(entity.getId(), annotation.typeData());
        for (String s : entity.getAssociations()) {
            s = StringUtils.trim(s);
            if (!s.isEmpty())
                commonMapper.saveAssociations(s, entity.getId(), annotation.typeData(), parentId);
        }

    }

}
