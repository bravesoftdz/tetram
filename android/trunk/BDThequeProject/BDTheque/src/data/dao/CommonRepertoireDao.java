package org.tetram.bdtheque.data.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.factories.BeanFactory;
import org.tetram.bdtheque.database.DBUtils;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public abstract class CommonRepertoireDao<B extends CommonBean & TreeNodeBean, I extends InitialeBean>
        extends CommonDaoImpl<B>
        implements InitialeRepertoireDao<B, I> {

    private final Class<? extends BeanFactory<B>> beanFactoryClass;
    private final Class<I> initialeClass;
    private String filtre;

    protected CommonRepertoireDao(Context context, Class<I> initialeClass, Class<? extends BeanFactory<B>> beanFactoryClass) {
        super(context);
        this.initialeClass = initialeClass;
        this.beanFactoryClass = beanFactoryClass;
    }

    public List<B> getData(int resId, InitialeBean initiale) {
        return getData(resId, initiale, null);
    }

    public List<B> getData(int resId, InitialeBean initiale, String filtre) {
        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        String v = initiale.getValue();
        String[] params = null;
        String sWhere;
        if ((v == null) || "-1".equals(v))
            sWhere = "is null";
        else {
            sWhere = " = ?";
            params = new String[]{v};
        }
        sWhere += filtre == null || "".equals(filtre) ? "" : " and " + filtre;
        Cursor cursor = rdb.rawQuery(getContext().getString(resId, sWhere), params);

        List<B> result = new ArrayList<>();
        BeanFactory<B> beanFactory = null;
        try {
            beanFactory = this.beanFactoryClass.getConstructor().newInstance();
        } catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
            e.printStackTrace();
        }

        while (cursor.moveToNext()) {
            result.add(beanFactory.loadFromCursor(getContext(), cursor, true));
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    private List<I> getInitiales(String sql) {
        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        Cursor cursor = rdb.rawQuery(sql, null);

        int cValue = (cursor.getColumnCount() == 2) ? 0 : 2;
        List<I> result = new ArrayList<>();
        while (cursor.moveToNext()) {
            result.add((I) InitialeBean.createInstance(this.initialeClass, cursor.getString(0), cursor.getInt(1), cursor.getString(cValue)));
        }
        return result;
    }

    public final List<I> getInitiales(int resId) {
        return getInitiales(resId, "");
    }

    public final List<I> getInitiales(int resId, String filtre) {
        return getInitiales(getContext().getString(resId, ((filtre == null) || "".equals(filtre)) ? "" : (" and " + filtre)));
    }

    public final List<I> getInitiales(String tableName, String fieldName, String filtre) {
        return getInitiales(getContext().getString(R.string.sql_initiales, tableName, fieldName, filtre));
    }

    @Override
    public void setFiltre(String filtre) {
        this.filtre = filtre;
    }

    @Override
    public String getFiltre() {
        return this.filtre;
    }

    public String getFiltre(int resId) {
        return getFiltre(getContext().getString(resId));
    }

    public String getFiltre(String searchField) {
        if ((this.filtre == null) || "".equals(this.filtre))
            return "";
        else
            return String.format("%s like %s", searchField, DBUtils.quotedStr("%" + this.filtre + "%"));
    }

    @Nullable
    @Override
    public B getById(UUID beanId) {
        return null;
    }
}
