package org.tetram.bdtheque.gui.utils;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.bean.lite.PersonneLiteBean;
import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteAnneeDao;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteCollectionDao;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteDao;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteEditeurDao;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteGenreDao;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteSerieDao;
import org.tetram.bdtheque.data.dao.lite.PersonneLiteDao;
import org.tetram.bdtheque.data.dao.lite.SerieLiteDao;
import org.tetram.bdtheque.gui.adapters.MenuEntry;

@SuppressWarnings("UnusedDeclaration")
public enum ModeRepertoire {
    REPERTOIRE_ALBUMS_TITRE(10, R.string.menuRepertoireAlbumsTitre, AlbumLiteDao.class, AlbumLiteBean.class, false),
    REPERTOIRE_ALBUMS_SERIE(11, R.string.menuRepertoireAlbumsSerie, AlbumLiteSerieDao.class, AlbumLiteBean.class, true),
    REPERTOIRE_ALBUMS_EDITEUR(12, R.string.menuRepertoireAlbumsEditeur, AlbumLiteEditeurDao.class, AlbumLiteBean.class, false),
    REPERTOIRE_ALBUMS_GENRE(13, R.string.menuRepertoireAlbumsGenre, AlbumLiteGenreDao.class, AlbumLiteBean.class, false),
    REPERTOIRE_ALBUMS_ANNEE(14, R.string.menuRepertoireAlbumsAnnee, AlbumLiteAnneeDao.class, AlbumLiteBean.class, false),
    REPERTOIRE_ALBUMS_COLLECTION(15, R.string.menuRepertoireAlbumsCollection, AlbumLiteCollectionDao.class, AlbumLiteBean.class, false),
    REPERTOIRE_SERIES(20, R.string.menuRepertoireSeries, SerieLiteDao.class, SerieLiteBean.class, false),
    REPERTOIRE_PERSONNES(30, R.string.menuRepertoirePersonnes, PersonneLiteDao.class, PersonneLiteBean.class, false);

    private final int value;
    private final int resId;
    private final Class<? extends InitialeRepertoireDao<?, ?>> daoClass;
    private final Class<? extends CommonBean> beanClass;
    private final boolean defaultMode;

    ModeRepertoire(final int value, final int resId, final Class<? extends InitialeRepertoireDao<?, ?>> daoClass, Class<? extends CommonBean> beanClass, final boolean defaultMode) {
        this.value = value;
        this.resId = resId;
        this.daoClass = daoClass;
        this.beanClass = beanClass;
        this.defaultMode = defaultMode;
    }

    @SuppressWarnings("UnusedDeclaration")
    public int getValue() {
        return this.value;
    }

    public int getResId() {
        return this.resId;
    }

    public Class<? extends InitialeRepertoireDao<?, ?>> getDaoClass() {
        return this.daoClass;
    }

    public MenuEntry getMenuEntry(final Context context) {
        return new MenuEntry(context.getString(getResId()), this.ordinal());
    }

    public boolean isDefault() {
        return this.defaultMode;
    }

    public Class<? extends CommonBean> getBeanClass() {
        return this.beanClass;
    }
}
