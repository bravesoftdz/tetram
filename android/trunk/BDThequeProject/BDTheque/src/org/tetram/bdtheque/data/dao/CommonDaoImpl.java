package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.database.BDDatabaseHelper;

@SuppressWarnings("UnusedDeclaration")
public abstract class CommonDaoImpl<T> implements CommonDao<T> {

    private final BDDatabaseHelper databaseHelper;
    private final Context context;

    public CommonDaoImpl(Context context) {
        super();
        this.databaseHelper = new BDDatabaseHelper(context);
        this.context = context;
    }

    @Override
    public BDDatabaseHelper getDatabaseHelper() {
        return this.databaseHelper;
    }

    @Override
    public Context getContext() {
        return this.context;
    }

}
