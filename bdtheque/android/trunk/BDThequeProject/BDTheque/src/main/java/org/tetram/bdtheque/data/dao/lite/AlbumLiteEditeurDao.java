package org.tetram.bdtheque.data.dao.lite;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeFormatedBean;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.dao.CommonRepertoireDao;

import java.util.List;

public class AlbumLiteEditeurDao extends CommonRepertoireDao<AlbumLiteBean, InitialeFormatedBean> {

    public AlbumLiteEditeurDao() {
        super(InitialeFormatedBean.class);
    }

    private String buildFiltre() {
        String filtre = getFiltre(R.string.sql_searchfield_albums);
        if (!"".equals(filtre)) filtre += " and ";
        return filtre;
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<InitialeFormatedBean> getInitiales() {
        return super.getInitiales(R.string.sql_editeurs_albums, buildFiltre() + "a.nbeditions > 0");
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<AlbumLiteBean> getData(InitialeFormatedBean initiale) {
        return super.getData(R.string.sql_albums_by_editeur, initiale, buildFiltre() + "a.nbeditions > 0");
    }

}
