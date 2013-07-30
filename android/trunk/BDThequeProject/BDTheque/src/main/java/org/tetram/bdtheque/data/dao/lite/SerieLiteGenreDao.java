package org.tetram.bdtheque.data.dao.lite;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.dao.CommonRepertoireDao;
import org.tetram.bdtheque.data.factories.lite.SerieLiteFactory;

import java.util.List;

public class SerieLiteGenreDao extends CommonRepertoireDao<SerieLiteBean, InitialeBean> {

    public SerieLiteGenreDao(Context context) {
        super(context, InitialeBean.class, SerieLiteFactory.class);
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<InitialeBean> getInitiales() {
        return super.getInitiales(R.string.sql_genres_series, getFiltre(R.string.sql_searchfield_series));
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<SerieLiteBean> getData(InitialeBean initiale) {
        return super.getData(R.string.sql_series_by_genre, initiale, getFiltre(R.string.sql_searchfield_series));
    }

}
