package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.LoadDescriptor;
import org.tetram.bdtheque.utils.GenericUtils;

@SuppressWarnings("FieldCanBeLocal")
public abstract class BeanFactoryImpl<T extends CommonBean> implements BeanFactory<T> {

    @SuppressWarnings({"FieldCanBeLocal", "UnusedDeclaration"})

    private final Class<T> beanClass;

    @SuppressWarnings("unchecked")
    public BeanFactoryImpl() {
        super();
        this.beanClass = (Class<T>) GenericUtils.getTypeArguments(BeanFactoryImpl.class, getClass()).get(0);
    }

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, LoadDescriptor loadDescriptor, T bean) {
        return true;
    }

}
