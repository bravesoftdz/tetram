package org.tetram.bdtheque.data.factories.lite;

import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.factories.BeanFactoryImpl;

public abstract class AlbumLiteAbstractFactory<T extends AlbumLiteBean> extends BeanFactoryImpl<T> {

    public static class AlbumLiteFactory extends AlbumLiteAbstractFactory<AlbumLiteBean> {
    }

    public static class AlbumWithoutSerieLiteFactory extends AlbumLiteAbstractFactory<AlbumLiteBean.AlbumWithoutSerieLiteBean> {
    }

}
