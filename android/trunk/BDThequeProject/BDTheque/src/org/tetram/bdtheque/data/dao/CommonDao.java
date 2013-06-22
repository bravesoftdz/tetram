package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.database.BDDatabaseHelper;

public interface CommonDao<T> {
    BDDatabaseHelper getDatabaseHelper();

    Context getContext();
}
