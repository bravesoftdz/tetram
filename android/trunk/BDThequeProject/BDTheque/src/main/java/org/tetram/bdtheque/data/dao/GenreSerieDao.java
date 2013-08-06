package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.GenreSerieBean;
import org.tetram.bdtheque.data.bean.abstracts.SerieBeanAbstract;
import org.tetram.bdtheque.data.orm.QueryInfo;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

import static org.tetram.bdtheque.data.orm.Core.getQueryInfo;

public class GenreSerieDao extends CommonDaoImpl<GenreSerieBean> {

    public void loadListForSerie(List<GenreSerieBean> list, SerieBeanAbstract serie) {
        list.clear();

        QueryInfo queryInfo = getQueryInfo(this.getBeanClass());

        String filtre = String.format("%s = ?", queryInfo.getFullFieldname("serie"));
        String order = queryInfo.getFullFieldname("genre.nom");

        List<GenreSerieBean> tmpList = getList(filtre, new String[]{StringUtils.UUIDToGUIDString(serie.getId())}, order);

        list.addAll(tmpList);
    }

}
