package org.tetram.bdtheque.data.dao;

import android.content.Context;
import org.tetram.bdtheque.database.DatabaseHelper;

public abstract class CommonDao<T> {

    private DatabaseHelper db;
    private Context context;

    public CommonDao(Context context) {
        db = new DatabaseHelper(context);
        this.context = context;
    }

    public DatabaseHelper getDb() {
        return db;
    }

    public Context getContext() {
        return context;
    }

}
