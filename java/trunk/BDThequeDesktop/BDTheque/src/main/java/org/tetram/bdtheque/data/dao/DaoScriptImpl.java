package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;
import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.bean.AbstractScriptEntity;
import org.tetram.bdtheque.data.bean.ScriptInfo;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;

/**
 * Created by Thierry on 12/06/2014.
 */
public abstract class DaoScriptImpl<T extends AbstractScriptEntity, PK> extends DaoRWImpl<T, PK> implements DaoScript<T> {

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

        Map<String, Object> params = new HashMap<>();
        params.put("id", entity.getId());
        params.put("typeData", annotation.typeData());

        SqlSession session = getSqlSession();

        List<String> list = session.selectList("fillAssociations", params);
        Set<String> set = new HashSet<>();
        set.addAll(list);
        entity.setAssociations(set);
    }

    @SuppressWarnings("HardCodedStringLiteral")
    @Override
    public void saveAssociations(@NotNull T entity) {
        ScriptInfo annotation = type.getAnnotation(ScriptInfo.class);
        assert annotation != null;

        UUID parentId = null;
        if (!"".equals(annotation.getParentIdMethod())) {
            try {
                Method method = type.getMethod(annotation.getParentIdMethod());
                assert method != null;
                parentId = (UUID) method.invoke(entity);
            } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
                e.printStackTrace();
            }
        }

        SqlSession session = getSqlSession();

        Map<String, Object> params = new HashMap<>();
        params.put("id", entity.getId());
        params.put("typeData", annotation.typeData());

        session.delete("cleanAssociations", params);

        params.put("parentId", parentId);
        for (String s : entity.getAssociations()) {
            params.put("chaine", s);
            session.update("saveAssociations", params);
        }
    }
}
