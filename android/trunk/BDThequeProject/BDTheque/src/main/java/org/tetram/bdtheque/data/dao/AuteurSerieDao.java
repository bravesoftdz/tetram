package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.data.bean.AuteurSerieBean;
import org.tetram.bdtheque.data.bean.abstracts.SerieBeanAbstract;
import org.tetram.bdtheque.data.utils.DaoUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

public class AuteurSerieDao extends CommonDaoImpl<AuteurSerieBean> {
    public AuteurSerieDao(Context context) {
        super(context);
    }

    public List<AuteurSerieBean> getAuteurs(SerieBeanAbstract serie) {
        DaoUtils.QueryInfo queryInfo = DaoUtils.getQueryInfo(this.getBeanClass());
        String filtre = String.format("%s = ?", DaoUtils.getFullFieldname(queryInfo, "serie"));
        return getList(filtre, new String[]{StringUtils.UUIDToGUIDString(serie.getId())}, null);
    }

}
