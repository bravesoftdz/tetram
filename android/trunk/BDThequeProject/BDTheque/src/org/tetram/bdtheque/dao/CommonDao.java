package org.tetram.bdtheque.dao;

import android.content.Context;

import org.tetram.bdtheque.database.DatabaseHelper;

/**
 * Created by Thierry on 02/06/13.
 */
public class CommonDao<T> {

    private DatabaseHelper db;

    public CommonDao(Context context) {
        db = new DatabaseHelper(context);
    }

    public DatabaseHelper getDb() {
        return db;
    }

}
