package org.tetram.bdtheque.data.dao.lite;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.InitialeSerieBean;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.dao.CommonRepertoireDao;
import org.tetram.bdtheque.data.factories.lite.AlbumLiteAbstractFactory;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;
import java.util.UUID;

public class AlbumLiteSerieDao extends CommonRepertoireDao<AlbumLiteBean.AlbumWithoutSerieLiteBean, InitialeSerieBean> {

    public AlbumLiteSerieDao(Context context) {
        super(context, InitialeSerieBean.class, AlbumLiteAbstractFactory.AlbumWithoutSerieLiteFactory.class);
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
    public List<AlbumLiteBean.AlbumWithoutSerieLiteBean> getData(InitialeSerieBean initiale) {
        return super.getData(R.string.sql_albums_by_serie, initiale, buildFiltre() + "a.nbeditions > 0");
    }

    public void loadListForSerie(List<AlbumLiteBean> list, UUID serieId) {
        list.clear();
        list.addAll(super.getData(R.string.sql_albums_by_serie, InitialeBean.createInstance(InitialeSerieBean.class, null, 0, StringUtils.UUIDToGUIDString(serieId))));
    }


}
