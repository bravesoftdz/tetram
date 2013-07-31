package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.data.bean.AuteurAlbumBean;
import org.tetram.bdtheque.data.bean.abstracts.AlbumBeanAbstract;
import org.tetram.bdtheque.data.utils.DaoUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

public class AuteurAlbumDao extends CommonDaoImpl<AuteurAlbumBean> {
    public AuteurAlbumDao(Context context) {
        super(context);
    }

    public List<AuteurAlbumBean> getAuteurs(AlbumBeanAbstract album) {
        DaoUtils.QueryInfo queryInfo = DaoUtils.getQueryInfo(this.getBeanClass());
        String filtre = String.format("%s = ?", DaoUtils.getFullFieldname(queryInfo, "album"));
        return getList(filtre, new String[]{StringUtils.UUIDToGUIDString(album.getId())}, null);
    }

}
