package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.ImageBean;
import org.tetram.bdtheque.data.bean.abstracts.AlbumBeanAbstract;
import org.tetram.bdtheque.data.bean.lite.EditionLiteBean;
import org.tetram.bdtheque.data.orm.QueryInfo;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

import static org.tetram.bdtheque.data.orm.Core.getQueryInfo;

public class ImageDao extends CommonDaoImpl<ImageBean> {

    @SuppressWarnings("UnusedDeclaration")
    public void loadListForAlbum(List<ImageBean> list, AlbumBeanAbstract album) {
        list.clear();

        QueryInfo queryInfo = getQueryInfo(this.getBeanClass());

        String filtre = String.format("%s = ?", queryInfo.getFullFieldname("album"));
        String order = queryInfo.getFullFieldname("ordre");

        List<ImageBean> tmpList = getList(filtre, new String[]{StringUtils.UUIDToGUIDString(album.getId())}, order);

        list.addAll(tmpList);
    }

    public void loadListForEdition(List<ImageBean> list, EditionLiteBean edition) {
        list.clear();

        QueryInfo queryInfo = getQueryInfo(this.getBeanClass());

        String filtre = String.format("%s = ?", queryInfo.getFullFieldname("edition"));
        String order = queryInfo.getFullFieldname("ordre");

        List<ImageBean> tmpList = getList(filtre, new String[]{StringUtils.UUIDToGUIDString(edition.getId())}, order);

        list.addAll(tmpList);
    }

}
