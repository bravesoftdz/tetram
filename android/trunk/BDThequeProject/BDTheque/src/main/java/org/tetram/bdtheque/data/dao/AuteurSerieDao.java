package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.AuteurSerieBean;
import org.tetram.bdtheque.data.bean.abstracts.SerieBeanAbstract;
import org.tetram.bdtheque.data.orm.QueryInfo;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

import static org.tetram.bdtheque.data.orm.Core.getQueryInfo;

public class AuteurSerieDao extends CommonDaoImpl<AuteurSerieBean> {

    public List<AuteurSerieBean> getAuteurs(SerieBeanAbstract serie) {
        QueryInfo queryInfo = getQueryInfo(this.getBeanClass());
        String filtre = String.format("%s = ?", queryInfo.getFullFieldname("serie"));
        return getList(filtre, new String[]{StringUtils.UUIDToGUIDString(serie.getId())}, null);
    }

}
