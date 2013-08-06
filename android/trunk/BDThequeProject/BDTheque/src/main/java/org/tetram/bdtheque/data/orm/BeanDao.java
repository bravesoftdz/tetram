package org.tetram.bdtheque.data.orm;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQueryBuilder;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static org.tetram.bdtheque.data.orm.BeanLoader.loadFromCursor;

public abstract class BeanDao {

    private BeanDao() {
        super();
    }

    @SuppressWarnings("StringBufferReplaceableByString")
    @Nullable
    public static <T extends CommonBean> T getById(Class<T> beanClass, UUID beanId, SQLiteDatabase rdb) {
        if ((beanId == null) || beanId.equals(StringUtils.GUID_FULL) || beanId.equals(StringUtils.GUID_NULL))
            return null;
        assert rdb != null;

        QueryInfo queryInfo = Core.getQueryInfo(beanClass);

        StringBuilder tableList = new StringBuilder(150);
        for (String table : queryInfo.getTables())
            tableList.append(table).append(" ");

        SQLiteQueryBuilder qryBuilder = new SQLiteQueryBuilder();

        qryBuilder.setDistinct(false);
        qryBuilder.setTables(tableList.toString());
        qryBuilder.setProjectionMap(queryInfo.getSqlAliasMapping());

        SQLDescriptor descriptor = Core.getSQLDescriptor(beanClass);
        final String sql = qryBuilder.buildQuery(
                queryInfo.getFields().toArray(new String[queryInfo.getFields().size()]),
                String.format("%s = ?", queryInfo.getColumns().get(descriptor.getPrimaryKey().getField()).getFullFieldName()),
                null,
                null,
                null,
                null
        );

        Cursor cursor = rdb.rawQuery(sql, new String[]{StringUtils.UUIDToGUIDString(beanId)});

        try {
            if (cursor.moveToFirst())
                return BeanLoader.loadFromCursor(
                        beanClass,
                        cursor,
                        queryInfo.getLoadDescriptor() != null,
                        queryInfo.getLoadDescriptor()
                );
        } finally {
            cursor.close();
        }

        return null;
    }

    public static <T extends CommonBean> T getById(Class<T> beanClass, UUID beanId) {
        SQLiteDatabase rdb = Core.getDatabaseHelper().getReadableDatabase();
        try {
            return getById(beanClass, beanId, rdb);
        } finally {
            rdb.close();
        }

    }

    public static <T extends CommonBean> List<T> getList(Class<T> beanClass, String criteria, String[] selectionArgs, String orderBy) {
        SQLiteDatabase rdb = Core.getDatabaseHelper().getReadableDatabase();
        try {
            return getList(beanClass, criteria, selectionArgs, orderBy, rdb);
        } finally {
            rdb.close();
        }
    }

    @SuppressWarnings({"StringBufferReplaceableByString", "unchecked"})
    public static <T extends CommonBean> List<T> getList(Class<T> beanClass, String criteria, String[] selectionArgs, String orderBy, SQLiteDatabase rdb) {
        assert rdb != null;

        QueryInfo queryInfo = Core.getQueryInfo(beanClass);

        StringBuilder tableList = new StringBuilder(150);
        for (String table : queryInfo.getTables())
            tableList.append(table).append(" ");

        SQLiteQueryBuilder qryBuilder = new SQLiteQueryBuilder();

        qryBuilder.setDistinct(false);
        qryBuilder.setTables(tableList.toString());
        qryBuilder.setProjectionMap(queryInfo.getSqlAliasMapping());

        final String sql = qryBuilder.buildQuery(
                queryInfo.getFields().toArray(new String[queryInfo.getFields().size()]),
                criteria,
                null,
                null,
                orderBy,
                null
        );

        List<T> result = new ArrayList<T>();

        Cursor cursor = rdb.rawQuery(sql, selectionArgs);

        try {
            if (cursor.moveToFirst())
                do {
                    result.add(loadFromCursor(
                            beanClass,
                            cursor,
                            queryInfo.getLoadDescriptor() != null,
                            queryInfo.getLoadDescriptor()
                    ));
                }
                while (cursor.moveToNext());
        } finally {
            cursor.close();
        }

        return result;
    }

}
