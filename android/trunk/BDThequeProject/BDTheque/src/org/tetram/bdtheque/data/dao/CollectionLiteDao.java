package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.factories.CollectionLiteFactory;

import java.util.List;

@SuppressWarnings("UnusedDeclaration")
public class CollectionLiteDao extends CommonRepertoireDao<CollectionLiteBean, InitialeBean> {

    public CollectionLiteDao(Context context) {
        super(context, InitialeBean.class, CollectionLiteFactory.class);
    }

    @Override
    public List<InitialeBean> getInitiales() {
        return super.getInitiales(R.string.sql_initiales_collections, getFiltre(R.string.sql_searchfield_collections));
    }

    @Override
    public List<CollectionLiteBean> getData(InitialeBean initiale) {
        return super.getData(R.string.sql_collections_by_initiale, initiale, getFiltre(R.string.sql_searchfield_collections));
    }
}
