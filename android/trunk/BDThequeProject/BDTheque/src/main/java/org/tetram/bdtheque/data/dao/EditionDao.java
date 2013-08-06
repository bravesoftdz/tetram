package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.bean.abstracts.AlbumBeanAbstract;
import org.tetram.bdtheque.data.orm.QueryInfo;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

import static org.tetram.bdtheque.data.orm.Core.getQueryInfo;

public class EditionDao extends CommonDaoImpl<EditionBean> {

    public void loadListForAlbum(List<EditionBean> editions, AlbumBeanAbstract album) {
        loadListForAlbum(editions, album, null);
    }

    @SuppressWarnings("UnusedParameters")
    public void loadListForAlbum(List<EditionBean> editions, AlbumBeanAbstract album, Boolean stock) {
        editions.clear();

        QueryInfo queryInfo = getQueryInfo(this.getBeanClass());
        String filtre = String.format("%s = ?", queryInfo.getFullFieldname("album"));
        List<EditionBean> tmpList = getList(filtre, new String[]{StringUtils.UUIDToGUIDString(album.getId())}, null);

        editions.addAll(tmpList);
    }
}
