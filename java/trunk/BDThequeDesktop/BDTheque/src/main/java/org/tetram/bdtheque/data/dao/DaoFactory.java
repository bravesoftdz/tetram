package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Thierry on 30/05/2014.
 */
public class DaoFactory {
    private static DaoFactory ourInstance = new DaoFactory();
    private Map<Class<? extends AbstractDao>, AbstractDao> daoMap = new HashMap<>();

    private DaoFactory() {
    }

    public static DaoFactory getInstance() {
        return ourInstance;
    }

    @SuppressWarnings("unchecked")
    @NotNull
    public <T extends AbstractDao> T getDao(Class<T> type) {
        AbstractDao abstractDao = daoMap.get(type);
        if (abstractDao == null) {
            try {
                abstractDao = type.newInstance();
                daoMap.put(type, abstractDao);
            } catch (InstantiationException | IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        assert abstractDao != null;
        return (T) abstractDao;
    }
}
