package org.tetram.bdtheque.gui.controllers.components;

import javafx.util.Callback;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.*;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAlbum;
import org.tetram.bdtheque.data.bean.abstractentities.BaseParaBD;
import org.tetram.bdtheque.data.dao.*;

import java.util.Arrays;
import java.util.EnumSet;
import java.util.List;

/**
 * Created by Thierry on 17/07/2014.
 */
public enum TreeViewMode {
    NONE(0),
    ALBUMS(1, AlbumLite.class, AlbumLiteDao.class, Constants.FILTRE_SQL_COMPLET),
    COLLECTIONS(2, CollectionLite.class, CollectionLiteDao.class),
    EDITEURS(3, EditeurLite.class, EditeurLiteDao.class),
    // EMPRUNTEURS(4),
    GENRES(5, GenreLite.class, GenreLiteDao.class),
    PERSONNES(6, PersonneLite.class, PersonneLiteDao.class),
    SERIES(7, SerieLite.class, SerieLiteDao.class),
    ALBUMS_ANNEE(8, AlbumLite.class, AlbumLiteAnneeDao.class, Constants.FILTRE_SQL_COMPLET),
    ALBUMS_COLLECTION(9, AlbumLite.class, AlbumLiteCollectionDao.class, Constants.FILTRE_SQL_COMPLET),
    ALBUMS_EDITEUR(10, AlbumLite.class, AlbumLiteEditeurDao.class, Constants.FILTRE_SQL_COMPLET),
    ALBUMS_GENRE(11, AlbumLite.class, AlbumLiteGenreDao.class, Constants.FILTRE_SQL_COMPLET),
    ALBUMS_SERIE(12, AlbumLite.class, AlbumLiteSerieDao.class, Constants.FILTRE_SQL_COMPLET),
    PARABD_SERIE(13, ParaBDLite.class, ParaBDLiteDao.class, Constants.FILTRE_SQL_COMPLET),
    ACHATS_ALBUMS_EDITEUR(14, AlbumLite.class, AlbumLiteSerieDao.class, Constants.FILTRE_SQL_ACHAT),
    UNIVERS(15, UniversLite.class, UniversLiteDao.class);

    private final int value;
    private final Class<? extends AbstractEntity> entityClass;
    private final Class<? extends RepertoireLiteDao> daoClass;
    private final String defaultFiltre;

    TreeViewMode(int value, Class<? extends AbstractEntity> entityClass, Class<? extends RepertoireLiteDao> daoClass) {
        this(value, entityClass, daoClass, null);
    }

    TreeViewMode(int value, Class<? extends AbstractEntity> entityClass, Class<? extends RepertoireLiteDao> daoClass, String defaultFiltre) {
        this.value = value;
        this.entityClass = entityClass;
        this.daoClass = daoClass;
        this.defaultFiltre = defaultFiltre;
    }

    TreeViewMode(int value) {
        this(value, null, null);
    }

    public static TreeViewMode fromValue(int value) {
        for (TreeViewMode treeViewMode : values())
            if (treeViewMode.value == value) return treeViewMode;
        return null;
    }

    public int getValue() {
        return value;
    }

    public Class<? extends AbstractEntity> getEntityClass() {
        return entityClass;
    }

    public Class<? extends RepertoireLiteDao> getDaoClass() {
        return daoClass;
    }

    public String getDefaultFiltre() {
        return defaultFiltre;
    }

    private static class Constants {
        @NonNls
        private static final String FILTRE_SQL_COMPLET = "Complet = 1";
        @NonNls
        private static final String FILTRE_SQL_ACHAT = "Achat = 1";
    }

    static class GetLabelCallback implements Callback<TreeViewController.TreeViewNode, String> {

        private final EnumSet<TreeViewMode> albumSansSerie = EnumSet.copyOf(Arrays.asList(new TreeViewMode[]{ALBUMS_SERIE}));
        private final EnumSet<TreeViewMode> parabdSansSerie = EnumSet.copyOf(Arrays.asList(new TreeViewMode[]{PARABD_SERIE}));

        private final TreeViewController treeViewController;

        public GetLabelCallback(TreeViewController treeViewController) {
            this.treeViewController = treeViewController;
        }

        @Override
        public String call(TreeViewController.TreeViewNode treeViewNode) {
            final AbstractEntity entity = treeViewNode.getValue();
            if (entity == null)
                return null;
            final TreeViewMode mode = treeViewController.getMode();
            if (albumSansSerie.contains(mode) && mode.entityClass.isAssignableFrom(entity.getClass()))
                return ((BaseAlbum) entity).buildLabel(false);
            else if (parabdSansSerie.contains(mode) && mode.entityClass.isAssignableFrom(entity.getClass()))
                return ((BaseParaBD) entity).buildLabel(false);
            else
                return entity.buildLabel();
        }
    }

    static class GetChildrenCallback implements Callback<TreeViewController.TreeViewNode, List<? extends AbstractEntity>> {

        private final TreeViewController treeViewController;

        public GetChildrenCallback(TreeViewController treeViewController) {
            this.treeViewController = treeViewController;
        }

        @SuppressWarnings("unchecked")
        @Override
        public List<? extends AbstractEntity> call(TreeViewController.TreeViewNode treeViewNode) {
            final AbstractEntity entity = treeViewNode.getValue();
            if (entity == null) {
                // c'est la racine
                return treeViewController.getDao().getInitiales(treeViewController.getAppliedFiltre());
            } else if (entity instanceof InitialeEntity) {
                // c'est le niveau 1
                return treeViewController.getDao().getListEntitiesByInitiale((InitialeEntity<?>) entity, treeViewController.getAppliedFiltre());
            }
            return null;
        }
    }
}
