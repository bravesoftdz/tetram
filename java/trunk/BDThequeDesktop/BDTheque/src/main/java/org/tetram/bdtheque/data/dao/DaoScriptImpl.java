package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.bean.AbstractScriptEntity;
import org.tetram.bdtheque.data.dao.mappers.CommonMapper;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.UUID;

/**
 * Created by Thierry on 12/06/2014.
 */
public abstract class DaoScriptImpl<T extends AbstractScriptEntity, PK> extends DaoRWImpl<T, PK> implements DaoScript<T> {

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

        UUID parentId = null;
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
        for (String s : entity.getAssociations())
            commonMapper.saveAssociations(s, entity.getId(), annotation.typeData(), parentId);

    }

    /**
     * Created by Thierry on 12/06/2014.
     */
    @Retention(RetentionPolicy.RUNTIME)
    @Target(ElementType.TYPE)
    public static @interface ScriptInfo {
        int typeData();

        String getParentIdMethod() default "";
    }
}
