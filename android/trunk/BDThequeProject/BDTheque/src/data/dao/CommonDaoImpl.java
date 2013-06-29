package org.tetram.bdtheque.data.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.factories.BeanFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.BDDatabaseHelper;
import org.tetram.bdtheque.utils.GenericUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.lang.reflect.InvocationTargetException;
import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
public abstract class CommonDaoImpl<T extends CommonBean> implements CommonDao<T> {

    private final BDDatabaseHelper databaseHelper;
    private final Context context;
    private final Class<?> beanClass;
    private final String tableName;
    private BeanFactory beanFactory;
    private final String primaryKey;

    public CommonDaoImpl(Context context) {
        super();
        this.databaseHelper = new BDDatabaseHelper(context);
        this.context = context;

        this.beanClass = GenericUtils.getTypeArguments(CommonDaoImpl.class, getClass()).get(0);
        Entity a = this.beanClass.getAnnotation(Entity.class);
        assert a != null;
        this.tableName = a.tableName();
        if ("".equals(a.primaryKey()))
            this.primaryKey = "id_" + a.tableName();
        else
            this.primaryKey = a.primaryKey();
        try {
            this.beanFactory = a.factoryClass().getConstructor().newInstance();
        } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
        }
    }

    @Override
    public BDDatabaseHelper getDatabaseHelper() {
        return this.databaseHelper;
    }

    @Override
    public Context getContext() {
        return this.context;
    }

    @SuppressWarnings("unchecked")
    @Nullable
    @Override
    public T getById(UUID beanId) {
        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        Cursor cursor = rdb.query(
                this.tableName,
                null,
                this.primaryKey + " = ?",
                new String[]{StringUtils.UUIDToGUIDString(beanId)},
                null,
                null,
                null
        );

        if (cursor.moveToFirst())
            return (T) this.beanFactory.loadFromCursor(getContext(), cursor, true);

        return null;
    }

}
