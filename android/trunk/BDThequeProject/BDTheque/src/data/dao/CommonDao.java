package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.database.BDDatabaseHelper;

import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
public interface CommonDao<T extends CommonBean> {
    BDDatabaseHelper getDatabaseHelper();

    Context getContext();

    @Nullable
    T getById(UUID beanId);

    @Nullable
    T getByParams(Object... param);

    T saveOrUpdate(T bean);
}
