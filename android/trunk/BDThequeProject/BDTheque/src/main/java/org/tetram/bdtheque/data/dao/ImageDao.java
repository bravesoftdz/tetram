package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.data.bean.ImageBean;
import org.tetram.bdtheque.data.bean.abstracts.AlbumBeanAbstract;
import org.tetram.bdtheque.data.bean.lite.EditionLiteBean;
import org.tetram.bdtheque.data.utils.DaoUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

public class ImageDao extends CommonDaoImpl<ImageBean> {
    public ImageDao(Context context) {
        super(context);
    }

    @SuppressWarnings("UnusedDeclaration")
    public void loadListForAlbum(List<ImageBean> list, AlbumBeanAbstract album) {
        list.clear();

        DaoUtils.QueryInfo queryInfo = DaoUtils.getQueryInfo(this.getBeanClass());

        String filtre = String.format("%s = ?", DaoUtils.getFullFieldname(queryInfo, "album"));
        String order = DaoUtils.getFullFieldname(queryInfo, "ordre");

        List<ImageBean> tmpList = getList(filtre, new String[]{StringUtils.UUIDToGUIDString(album.getId())}, order);

        list.addAll(tmpList);
    }

    public void loadListForEdition(List<ImageBean> list, EditionLiteBean edition) {
        list.clear();

        DaoUtils.QueryInfo queryInfo = DaoUtils.getQueryInfo(this.getBeanClass());

        String filtre = String.format("%s = ?", DaoUtils.getFullFieldname(queryInfo, "edition"));
        String order = DaoUtils.getFullFieldname(queryInfo, "ordre");

        List<ImageBean> tmpList = getList(filtre, new String[]{StringUtils.UUIDToGUIDString(edition.getId())}, order);

        list.addAll(tmpList);
    }

}
