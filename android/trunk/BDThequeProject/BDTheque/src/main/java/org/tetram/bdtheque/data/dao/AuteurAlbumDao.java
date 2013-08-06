package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.data.bean.AuteurAlbumBean;
import org.tetram.bdtheque.data.bean.abstracts.AlbumBeanAbstract;
import org.tetram.bdtheque.data.orm.QueryInfo;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

import static org.tetram.bdtheque.data.orm.Core.getQueryInfo;

public class AuteurAlbumDao extends CommonDaoImpl<AuteurAlbumBean> {

    public List<AuteurAlbumBean> getAuteurs(AlbumBeanAbstract album) {
        QueryInfo queryInfo = getQueryInfo(this.getBeanClass());
        String filtre = String.format("%s = ?", queryInfo.getFullFieldname("album"));
        return getList(filtre, new String[]{StringUtils.UUIDToGUIDString(album.getId())}, null);
    }

}
