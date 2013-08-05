package org.tetram.bdtheque.data.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQueryBuilder;
import android.util.Log;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.QueryInfo;
import org.tetram.bdtheque.data.orm.SQLDescriptor;
import org.tetram.bdtheque.utils.GenericUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static org.tetram.bdtheque.data.orm.BeanLoader.loadFromCursor;
import static org.tetram.bdtheque.data.orm.Core.getDatabaseHelper;
import static org.tetram.bdtheque.data.orm.Core.getQueryInfo;
import static org.tetram.bdtheque.data.orm.Core.getSQLDescriptor;

@SuppressWarnings({"unchecked", "UnusedDeclaration"})
public abstract class CommonDaoImpl<T extends CommonBean> extends DefaultDao<T> implements CommonDao<T> {

    private final Class<T> beanClass;
    private final SQLDescriptor descriptor;

    public CommonDaoImpl(Context context) {
        super(context);
        this.beanClass = (Class<T>) GenericUtils.getTypeArguments(CommonDaoImpl.class, getClass()).get(0);
        this.descriptor = getSQLDescriptor(this.beanClass);
    }

    public Class<T> getBeanClass() {
        return this.beanClass;
    }

    public SQLDescriptor getDescriptor() {
        return this.descriptor;
    }

    @SuppressWarnings({"unchecked", "StringBufferReplaceableByString"})
    @Nullable
    @Override
    public T getById(UUID beanId) {
        if ((beanId == null) || beanId.equals(StringUtils.GUID_FULL) || beanId.equals(StringUtils.GUID_NULL))
            return null;

        QueryInfo queryInfo = getQueryInfo(this.beanClass);

        StringBuilder tableList = new StringBuilder(150);
        for (String table : queryInfo.getTables())
            tableList.append(table).append(" ");

        SQLiteQueryBuilder qryBuilder = new SQLiteQueryBuilder();

        qryBuilder.setDistinct(false);
        qryBuilder.setTables(tableList.toString());
        qryBuilder.setProjectionMap(queryInfo.getSqlAliasMapping());

        final String sql = qryBuilder.buildQuery(
                queryInfo.getFields().toArray(new String[queryInfo.getFields().size()]),
                String.format("%s = ?", queryInfo.getColumns().get(this.descriptor.getPrimaryKey().getField()).getFullFieldName()),
                null,
                null,
                null,
                null
        );

//        Log.i(getClass().getCanonicalName(), sql);

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
            Cursor cursor = rdb.rawQuery(sql, new String[]{StringUtils.UUIDToGUIDString(beanId)});

            try {
                if (cursor.moveToFirst())
                    return loadFromCursor(
                            this.beanClass,
                            getContext(),
                            cursor,
                            queryInfo.getLoadDescriptor() != null,
                            queryInfo.getLoadDescriptor()
                    );
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }

        return null;
    }

    @Nullable
    @Override
    public List<T> getListFor(Class<? extends CommonBean> bean, String orderBy) {
        return null;
    }

    @SuppressWarnings("StringBufferReplaceableByString")
    public <T extends CommonBean> List<T> getListForBean(Class<T> listItemType, String criteria, String[] selectionArgs, String orderBy) {
        QueryInfo queryInfo = getQueryInfo(listItemType);

        StringBuilder tableList = new StringBuilder(150);
        for (String table : queryInfo.getTables())
            tableList.append(table).append(" ");

        SQLiteQueryBuilder qryBuilder = new SQLiteQueryBuilder();

        qryBuilder.setDistinct(false);
        qryBuilder.setTables(tableList.toString());
        qryBuilder.setProjectionMap(queryInfo.getSqlAliasMapping());
        if (criteria != null) qryBuilder.appendWhere(criteria);

        final String sql = qryBuilder.buildQuery(
                queryInfo.getFields().toArray(new String[queryInfo.getFields().size()]),
                null, // String.format("%s = ?", queryInfo.getColumns().get(this.descriptor.getPrimaryKey().getField()).getFullFieldName()),
                null,
                null,
                orderBy,
                null
        );
        Log.i(getClass().getCanonicalName(), sql);

        List<T> result = new ArrayList<T>();

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
            Cursor cursor = rdb.rawQuery(sql, selectionArgs);

            try {
                if (cursor.moveToFirst())
                    do {
                        result.add(loadFromCursor(
                                listItemType,
                                getContext(),
                                cursor,
                                queryInfo.getLoadDescriptor() != null,
                                queryInfo.getLoadDescriptor()
                        ));
                    }
                    while (cursor.moveToNext());
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }

        return result;
    }

    @SuppressWarnings({"StringBufferReplaceableByString", "unchecked"})
    public List<T> getList(String criteria, String[] selectionArgs, String orderBy) {
        QueryInfo queryInfo = getQueryInfo(this.beanClass);

        StringBuilder tableList = new StringBuilder(150);
        for (String table : queryInfo.getTables())
            tableList.append(table).append(" ");

        SQLiteQueryBuilder qryBuilder = new SQLiteQueryBuilder();

        qryBuilder.setDistinct(false);
        qryBuilder.setTables(tableList.toString());
        qryBuilder.setProjectionMap(queryInfo.getSqlAliasMapping());
        if (criteria != null) qryBuilder.appendWhere(criteria);

        final String sql = qryBuilder.buildQuery(
                queryInfo.getFields().toArray(new String[queryInfo.getFields().size()]),
                null, // String.format("%s = ?", queryInfo.getColumns().get(this.descriptor.getPrimaryKey().getField()).getFullFieldName()),
                null,
                null,
                orderBy,
                null
        );
        Log.i(getClass().getCanonicalName(), sql);

        List<T> result = new ArrayList<T>();

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
            Cursor cursor = rdb.rawQuery(sql, selectionArgs);

            try {
                if (cursor.moveToFirst())
                    do {
                        result.add(loadFromCursor(
                                this.beanClass,
                                getContext(),
                                cursor,
                                queryInfo.getLoadDescriptor() != null,
                                queryInfo.getLoadDescriptor()
                        ));
                    }
                    while (cursor.moveToNext());
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }

        return result;
    }

    @Override
    public T saveOrUpdate(T bean) {
        SQLiteDatabase wdb = getDatabaseHelper().getWritableDatabase();
        try {
            if (bean.getId() == null)
                wdb.insert(
                        this.descriptor.getTableName(),
                        null,
                        null
                );
            else
                wdb.update(
                        this.descriptor.getTableName(),
                        null,
                        this.descriptor.getPrimaryKey().getDbFieldName() + " = ?",
                        new String[]{StringUtils.UUIDToGUIDString(bean.getId())}
                );
        } finally {
            wdb.close();
        }
        return bean;
    }

}
