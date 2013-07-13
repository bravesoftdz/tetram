package org.tetram.bdtheque.data.dao.lite;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeSerieBean;
import org.tetram.bdtheque.data.dao.CommonRepertoireDao;
import org.tetram.bdtheque.data.factories.lite.AlbumLiteFactory;
import org.tetram.bdtheque.data.lite.bean.AlbumLiteBean;

import java.util.List;

public class AlbumLiteSerieDao extends CommonRepertoireDao<AlbumLiteBean, InitialeSerieBean> {

    public AlbumLiteSerieDao(Context context) {
        super(context, InitialeSerieBean.class, AlbumLiteFactory.class);
    }

    private String buildFiltre() {
        String filtre = getFiltre(R.string.sql_searchfield_albums);
        if (!"".equals(filtre)) filtre += " and ";
        return filtre;
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<InitialeSerieBean> getInitiales() {
        return super.getInitiales(R.string.sql_series_albums, buildFiltre() + "a.nbeditions > 0");
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<AlbumLiteBean> getData(InitialeSerieBean initiale) {
        return super.getData(R.string.sql_albums_by_serie, initiale, buildFiltre() + "a.nbeditions > 0");
    }

}
