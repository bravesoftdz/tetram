package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.database.BDDatabaseHelper;

@SuppressWarnings("UnusedDeclaration")
public abstract class CommonDao<T> {

    private final BDDatabaseHelper databaseHelper;
    private final Context context;

    public CommonDao(Context context) {
        super();
        this.databaseHelper = new BDDatabaseHelper(context);
        this.context = context;
    }

    public BDDatabaseHelper getDatabaseHelper() {
        return this.databaseHelper;
    }

    public Context getContext() {
        return this.context;
    }

}
