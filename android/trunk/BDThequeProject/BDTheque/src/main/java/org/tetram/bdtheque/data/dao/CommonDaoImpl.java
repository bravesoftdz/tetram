package org.tetram.bdtheque.data.dao;

import android.database.sqlite.SQLiteDatabase;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.SQLDescriptor;
import org.tetram.bdtheque.utils.GenericUtils;
import org.tetram.bdtheque.utils.StringUtils;

import static org.tetram.bdtheque.data.orm.Core.getDatabaseHelper;
import static org.tetram.bdtheque.data.orm.Core.getSQLDescriptor;

@SuppressWarnings({"unchecked", "UnusedDeclaration"})
public abstract class CommonDaoImpl<T extends CommonBean> extends DefaultDao<T> implements CommonDao<T> {

    private final Class<T> beanClass;
    private final SQLDescriptor descriptor;

    public CommonDaoImpl() {
        super();
        this.beanClass = (Class<T>) GenericUtils.getTypeArguments(CommonDaoImpl.class, getClass()).get(0);
        this.descriptor = getSQLDescriptor(this.beanClass);
    }

    public Class<T> getBeanClass() {
        return this.beanClass;
    }

    public SQLDescriptor getDescriptor() {
        return this.descriptor;
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
