package org.tetram.bdtheque.data.dao.lite;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeFormatedBean;
import org.tetram.bdtheque.data.dao.CommonRepertoireDao;
import org.tetram.bdtheque.data.factories.lite.AlbumLiteFactory;
import org.tetram.bdtheque.data.lite.bean.AlbumLiteBean;

import java.util.List;

public class AlbumLiteCollectionDao extends CommonRepertoireDao<AlbumLiteBean, InitialeFormatedBean> {

    public AlbumLiteCollectionDao(Context context) {
        super(context, InitialeFormatedBean.class, AlbumLiteFactory.class);
    }

    private String buildFiltre() {
        String filtre = getFiltre(R.string.sql_searchfield_albums);
        if (!"".equals(filtre)) filtre += " and ";
        return filtre;
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<InitialeFormatedBean> getInitiales() {
        return super.getInitiales(R.string.sql_collections_albums, buildFiltre() + "a.nbeditions > 0");
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<AlbumLiteBean> getData(InitialeFormatedBean initiale) {
        return super.getData(R.string.sql_albums_by_collection, initiale, buildFiltre() + "a.nbeditions > 0");
    }

}
