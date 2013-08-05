package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.bean.abstracts.AlbumBeanAbstract;
import org.tetram.bdtheque.data.utils.DaoUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

public class EditionDao extends CommonDaoImpl<EditionBean> {
    public EditionDao(Context context) {
        super(context);
    }

    public void loadListForAlbum(List<EditionBean> editions, AlbumBeanAbstract album) {
        loadListForAlbum(editions, album, null);
    }

    @SuppressWarnings("UnusedParameters")
    public void loadListForAlbum(List<EditionBean> editions, AlbumBeanAbstract album, Boolean stock) {
        editions.clear();

        DaoUtils.QueryInfo queryInfo = DaoUtils.getQueryInfo(this.getBeanClass());
        String filtre = String.format("%s = ?", DaoUtils.getFullFieldname(queryInfo, "album"));
        List<EditionBean> tmpList = getList(filtre, new String[]{StringUtils.UUIDToGUIDString(album.getId())}, null);

        editions.addAll(tmpList);
    }
}
