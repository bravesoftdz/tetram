package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.factories.AlbumLiteFactory;

import java.util.List;

public class AlbumLiteAnneeDao extends CommonRepertoireDao<AlbumLiteBean, InitialeBean> {

    public AlbumLiteAnneeDao(Context context) {
        super(context, InitialeBean.class, AlbumLiteFactory.class);
    }

    private String buildFiltre() {
        String filtre = getFiltre(R.string.sql_searchfield_albums);
        if (!"".equals(filtre)) filtre += " and ";
        return filtre;
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<InitialeBean> getInitiales() {
        return super.getInitiales(R.string.sql_annees_albums, buildFiltre() + "a.nbeditions > 0");
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<AlbumLiteBean> getData(InitialeBean initiale) {
        return super.getData(R.string.sql_albums_by_annee, initiale, buildFiltre() + "a.nbeditions > 0");
    }

}
