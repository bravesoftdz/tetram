package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;

@SuppressWarnings("UnusedDeclaration")
public class DefaultDao<T extends CommonBean> {
    protected final Context context;

    public DefaultDao(Context context) {
        super();
        this.context = context;
    }

    public Context getContext() {
        return this.context;
    }
}
