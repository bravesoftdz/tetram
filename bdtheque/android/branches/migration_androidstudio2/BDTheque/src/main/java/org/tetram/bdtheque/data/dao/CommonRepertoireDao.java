package org.tetram.bdtheque.data.dao;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.database.DBUtils;

import java.util.ArrayList;
import java.util.List;

import static org.tetram.bdtheque.data.orm.BeanLoader.loadFromCursor;
import static org.tetram.bdtheque.data.orm.Core.getDatabaseHelper;

public abstract class CommonRepertoireDao<B extends CommonBean & TreeNodeBean, I extends InitialeBean>
        extends CommonDaoImpl<B>
        implements InitialeRepertoireDao<B, I> {

    private final Class<I> initialeClass;
    private String filtre = "";

    protected CommonRepertoireDao(Class<I> initialeClass) {
        super();
        this.initialeClass = initialeClass;
    }

    protected List<B> getData(int resId, InitialeBean initiale) {
        return getData(resId, initiale, null);
    }

    protected List<B> getData(int resId, InitialeBean initiale, String filtre) {
        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
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
            Cursor cursor = rdb.rawQuery(BDThequeApplication.getInstance().getString(resId, sWhere), params);
            try {
                List<B> result = new ArrayList<>();
                while (cursor.moveToNext()) {
                    result.add(loadFromCursor(this.getBeanClass(), cursor, true, null));
                }
                return result;
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }
    }

    @SuppressWarnings("unchecked")
    private List<I> getInitiales(String sql) {
        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        try {
            Cursor cursor = rdb.rawQuery(sql, null);
            try {
                int cValue = (cursor.getColumnCount() == 2) ? 0 : 2;
                List<I> result = new ArrayList<>();
                while (cursor.moveToNext()) {
                    result.add((I) InitialeBean.createInstance(this.initialeClass, cursor.getString(0), cursor.getInt(1), cursor.getString(cValue)));
                }
                return result;
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }
    }

    public final List<I> getInitiales(int resId) {
        return getInitiales(resId, "");
    }

    protected final List<I> getInitiales(int resId, String filtre) {
        return getInitiales(BDThequeApplication.getInstance().getString(resId, ((filtre == null) || "".equals(filtre)) ? "" : (" and " + filtre)));
    }

    protected final List<I> getInitiales(String tableName, String fieldName, String filtre) {
        return getInitiales(BDThequeApplication.getInstance().getString(R.string.sql_initiales, tableName, fieldName, filtre));
    }

    @Override
    public void setFiltre(String filtre) {
        this.filtre = filtre == null ? "" : filtre;
    }

    @Override
    public String getFiltre() {
        return this.filtre;
    }

    protected String getFiltre(int resId) {
        return getFiltre(BDThequeApplication.getInstance().getString(resId));
    }

    String getFiltre(String searchField) {
        if ((this.filtre == null) || "".equals(this.filtre))
            return "";
        else
            return String.format("%s like %s", searchField, DBUtils.quotedStr("%" + this.filtre + "%"));
    }

/*
    // pour les lite bean, la méthode est différente de {CommonDaoImpl#getById}
    @Nullable
    @Override
    public B getById(UUID beanId) {
        return null;
    }
*/
}
