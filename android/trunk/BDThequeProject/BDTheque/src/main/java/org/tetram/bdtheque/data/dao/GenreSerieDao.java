package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.data.bean.GenreSerieBean;
import org.tetram.bdtheque.data.bean.abstracts.SerieBeanAbstract;
import org.tetram.bdtheque.data.utils.DaoUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

public class GenreSerieDao extends CommonDaoImpl<GenreSerieBean> {
    public GenreSerieDao(Context context) {
        super(context);
    }

    public void loadListForSerie(List<GenreSerieBean> list, SerieBeanAbstract serie) {
        list.clear();

        DaoUtils.QueryInfo queryInfo = DaoUtils.getQueryInfo(this.getBeanClass());

        String filtre = String.format("%s = ?", DaoUtils.getFullFieldname(queryInfo, "serie"));
        String order = DaoUtils.getFullFieldname(queryInfo, "genre.nom");

        List<GenreSerieBean> tmpList = getList(filtre, new String[]{StringUtils.UUIDToGUIDString(serie.getId())}, order);

        list.addAll(tmpList);
    }

}
