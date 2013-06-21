package org.tetram.bdtheque.data.factories;

import android.content.Context;

import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

public class DaoFactory {
    @SuppressWarnings("unchecked")
    public static <T extends InitialeRepertoireDao<?, ?>> T getDao(Class<T> daoClass, Context context) {
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
