package org.tetram.bdtheque.data.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.factories.BeanFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.utils.GenericUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
public abstract class CommonDaoImpl<T extends CommonBean> extends DefaultDao<T> implements CommonDao<T> {

    private final Class<?> beanClass;
    final String tableName;
    BeanFactory beanFactory;
    final String[] primaryKey;

    public CommonDaoImpl(Context context) {
        super(context);

        this.beanClass = GenericUtils.getTypeArguments(CommonDaoImpl.class, getClass()).get(0);
        Entity a = this.beanClass.getAnnotation(Entity.class);
        assert a != null;
        this.tableName = a.tableName();
        if (a.primaryKey().length == 0)
            this.primaryKey = new String[]{"id_" + a.tableName()};
        else
            this.primaryKey = a.primaryKey();
        try {
            this.beanFactory = a.factoryClass().getConstructor().newInstance();
        } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
        }
    }

    public Class<?> getBeanClass() {
        return this.beanClass;
    }

    @SuppressWarnings("unchecked")
    @Nullable
    @Override
    public T getById(UUID beanId) {
        if ((beanId == null) || beanId.equals(StringUtils.GUID_FULL) || beanId.equals(StringUtils.GUID_NULL))
            return null;

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
            Cursor cursor = rdb.query(
                    this.tableName,
                    null,
                    this.primaryKey[0] + " = ?",
                    new String[]{StringUtils.UUIDToGUIDString(beanId)},
                    null,
                    null,
                    null
            );

            try {
                if (cursor.moveToFirst())
                    return (T) this.beanFactory.loadFromCursor(getContext(), cursor);
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }

        return null;
    }

    @SuppressWarnings("unchecked")
    @Nullable
    @Override
    public T getByParams(Object... param) {
        int maxParam = Math.min(param.length, this.primaryKey.length);
        String sWhere = "";
        List<String> sParams = new ArrayList<>();
        for (int i = 0; i < maxParam; i++) {
            sWhere = StringUtils.ajoutString(sWhere, this.primaryKey[i] + " = ?", " and ");
            final Object currentParam = param[i];
            if (currentParam instanceof UUID)
                sParams.add(StringUtils.UUIDToGUIDString((UUID) currentParam));
            else
                sParams.add(String.valueOf(currentParam));
        }

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
            Cursor cursor = rdb.query(
                    this.tableName,
                    null,
                    sWhere,
                    sParams.toArray(new String[sParams.size()]),
                    null,
                    null,
                    null
            );

            try {
                if (cursor.moveToFirst())
                    return (T) this.beanFactory.loadFromCursor(getContext(), cursor);
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }

        return null;
    }

    @Override
    public T saveOrUpdate(T bean) {
        SQLiteDatabase wdb = getDatabaseHelper().getWritableDatabase();
        try {
            if (bean.getId() == null)
                wdb.insert(
                        this.tableName,
                        null,
                        null
                );
            else
                wdb.update(
                        this.tableName,
                        null,
                        this.primaryKey[0] + " = ?",
                        new String[]{StringUtils.UUIDToGUIDString(bean.getId())}
                );
        } finally {
            wdb.close();
        }
        return bean;
    }

}
