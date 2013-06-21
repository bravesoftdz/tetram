package org.tetram.bdtheque.gui.utils;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.dao.AlbumLiteAnneeDao;
import org.tetram.bdtheque.data.dao.AlbumLiteCollectionDao;
import org.tetram.bdtheque.data.dao.AlbumLiteDao;
import org.tetram.bdtheque.data.dao.AlbumLiteEditeurDao;
import org.tetram.bdtheque.data.dao.AlbumLiteGenreDao;
import org.tetram.bdtheque.data.dao.AlbumLiteSerieDao;
import org.tetram.bdtheque.data.dao.AuteurLiteDao;
import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;
import org.tetram.bdtheque.data.dao.SerieLiteDao;
import org.tetram.bdtheque.gui.adapter.MenuEntry;

public enum ModeRepertoire {
    REPERTOIRE_ALBUMS_TITRE(10, R.string.menuRepertoireAlbumsTitre, AlbumLiteDao.class, false),
    REPERTOIRE_ALBUMS_SERIE(11, R.string.menuRepertoireAlbumsSerie, AlbumLiteSerieDao.class, true),
    REPERTOIRE_ALBUMS_EDITEUR(12, R.string.menuRepertoireAlbumsEditeur, AlbumLiteEditeurDao.class, false),
    REPERTOIRE_ALBUMS_GENRE(13, R.string.menuRepertoireAlbumsGenre, AlbumLiteGenreDao.class, false),
    REPERTOIRE_ALBUMS_ANNEE(14, R.string.menuRepertoireAlbumsAnnee, AlbumLiteAnneeDao.class, false),
    REPERTOIRE_ALBUMS_COLLECTION(15, R.string.menuRepertoireAlbumsCollection, AlbumLiteCollectionDao.class, false),
    REPERTOIRE_SERIES(20, R.string.menuRepertoireSeries, SerieLiteDao.class, false),
    REPERTOIRE_AUTEURS(30, R.string.menuRepertoireAuteurs, AuteurLiteDao.class, false);

    private final int value;
    private final int resId;
    private final Class<? extends InitialeRepertoireDao<?, ?>> daoClass;
    private final boolean defaultMode;

    ModeRepertoire(final int value, final int resId, final Class<? extends InitialeRepertoireDao<?, ?>> daoClass, final boolean defaultMode) {
        this.value = value;
        this.resId = resId;
        this.daoClass = daoClass;
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
}
