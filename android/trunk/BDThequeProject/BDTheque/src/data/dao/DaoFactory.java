package org.tetram.bdtheque.data.dao;

import android.content.Context;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

@SuppressWarnings("ClassNamePrefixedWithPackageName")
public class DaoFactory {
    @SuppressWarnings("unchecked")
    public static <T extends InitialeRepertoireDao<?, ?>> T getRepertoireDao(Class<T> daoClass, Context context) {
        InitialeRepertoireDao<?, ?> dao = null;
        try {
            Constructor<T> constructor = daoClass.getConstructor(Context.class);
            dao = constructor.newInstance(context);
        } catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
            e.printStackTrace();
        }

        return (T) dao;
    }
}
