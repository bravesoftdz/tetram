package org.tetram.bdtheque.data.dao;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

@SuppressWarnings("ClassNamePrefixedWithPackageName")
public class DaoFactory {

    @SuppressWarnings("unchecked")
    public static <T extends CommonDao<?>> T getDao(Class<T> daoClass) {
        CommonDao<?> dao = null;
        try {
            Constructor<T> constructor = daoClass.getConstructor();
            dao = constructor.newInstance();
        } catch (final InstantiationException | InvocationTargetException | NoSuchMethodException | IllegalAccessException e) {
            e.printStackTrace();
        }

        return (T) dao;
    }

    @SuppressWarnings("unchecked")
    public static <T extends InitialeRepertoireDao<?, ?>> T getRepertoireDao(Class<T> daoClass) {
        InitialeRepertoireDao<?, ?> dao = null;
        try {
            Constructor<T> constructor = daoClass.getConstructor();
            dao = constructor.newInstance();
        } catch (final InstantiationException | InvocationTargetException | IllegalAccessException | NoSuchMethodException e) {
            e.printStackTrace();
        }

        return (T) dao;
    }
}
