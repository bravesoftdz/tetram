package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.database.BDDatabaseHelper;

@SuppressWarnings("UnusedDeclaration")
public class DefaultDao<T extends CommonBean> {
    protected final BDDatabaseHelper databaseHelper;
    protected final Context context;

    public DefaultDao(Context context) {
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
