package org.tetram.bdtheque.data.factories;

import android.content.Context;
import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

public class DaoFactory {
    public static <T extends InitialeRepertoireDao<?, ?>> T getDao(Class<T> daoClass, Context context) {
        InitialeRepertoireDao<?, ?> dao = null;
        try {
            Constructor<T> c = daoClass.getConstructor(Context.class);
            dao = c.newInstance(context);
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }

        return (T) dao;
    }
}
