package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.utils.GenericUtils;

import java.lang.reflect.InvocationTargetException;

public abstract class BeanFactoryImpl<T extends CommonBean> implements BeanFactory<T> {

    private final Class<?> beanClass;

    public BeanFactoryImpl() {
        super();
        this.beanClass = GenericUtils.getTypeArguments(BeanFactoryImpl.class, getClass()).get(0);
    }

    @SuppressWarnings("unchecked")
    @Nullable
    @Override
    public T loadFromCursor(Context context, Cursor cursor, boolean mustExists) {
        T bean = null;
        try {
            bean = (T) this.beanClass.getConstructor().newInstance();
        } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
        }
        if (!loadFromCursor(context, cursor, mustExists, bean)) return null;
        return bean;
    }

    @Override
    public abstract boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, T bean);
}
