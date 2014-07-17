/**
 * Sample Skeleton for 'repertoire.fxml' Controller Class
 */

package org.tetram.bdtheque.gui.controllers;

import javafx.beans.binding.Bindings;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.fxml.FXML;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import javafx.scene.control.TreeTableView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.*;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseParaBD;
import org.tetram.bdtheque.data.dao.*;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.controllers.components.TreeViewController;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.HashMap;
import java.util.UUID;

@Controller
@FileLink("/org/tetram/bdtheque/gui/repertoire.fxml")
public class RepertoireController extends WindowController {

    @Autowired
    private ModeConsultationController modeConsultationController;

    @FXML
    private TabPane tabs;

    @FXML
    private Tab tabAlbums;
    @FXML
    private TreeViewController albumsController;
    @FXML
    private ChoiceBox<TypeRepertoireAlbumEntry> repertoireGroup;

    @FXML
    private Tab tabSeries;
    @FXML
    private TreeViewController seriesController;

    @FXML
    private Tab tabUnivers;
    @FXML
    private TreeViewController universController;

    @FXML
    private Tab tabAuteurs;
    @FXML
    private TreeViewController auteursController;

    @FXML
    private Tab tabParabd;
    @FXML
    private TreeViewController parabdController;
    @Autowired
    private ParaBDLiteDao paraBDLiteDao;

    @Autowired
    private UserPreferences userPreferences;

    private ObjectProperty<InfoTab> currentInfoTab = new SimpleObjectProperty<>();

    @SuppressWarnings("unchecked")
    @FXML
    void initialize() {
        // TODO simplifier tout ça par l'utilisation de l'enum TreeViewMode


        // pourquoi ça marchait avant avec <Tab, InfoTab> et que ça ne marche plus maintenant, mystère
        HashMap<String, InfoTab> tabView = new HashMap<>();
        final InfoTab infoTabAlbums = new InfoTab(tabAlbums, TypeRepertoireAlbumEntry.PAR_SERIE.daoClass, albumsController);
        tabView.put(tabAlbums.getId(), infoTabAlbums);
        tabView.put(tabSeries.getId(), new InfoTab(tabSeries, SerieLiteDao.class, seriesController));
        tabView.put(tabUnivers.getId(), new InfoTab(tabUnivers, UniversLiteDao.class, universController));
        tabView.put(tabAuteurs.getId(), new InfoTab(tabAuteurs, PersonneLiteDao.class, auteursController));
        tabView.put(tabParabd.getId(), new InfoTab(tabParabd, ParaBDLiteDao.class, parabdController));

        albumsController.setFinalEntityClass(AlbumLite.class);
        seriesController.setFinalEntityClass(SerieLite.class);
        universController.setFinalEntityClass(UniversLite.class);
        auteursController.setFinalEntityClass(PersonneLite.class);
        parabdController.setFinalEntityClass(ParaBDLite.class);

        for (InfoTab infoTab : tabView.values()) {
            final TreeViewController treeViewController = infoTab.getTreeViewController();

            treeViewController.setClickToShow(true);
            treeViewController.onGetChildrenProperty().setValue(treeItem -> {
                final RepertoireLiteDao dao = infoTab.getDao();
                final AbstractEntity entity = treeItem.getValue();
                if (entity == null) {
                    // c'est la racine
                    return dao.getInitiales(null);
                } else if (entity instanceof InitialeEntity) {
                    // c'est le niveau 1
                    return dao.getListEntitiesByInitiale((InitialeEntity<UUID>) entity, null);
                }
                return null;
            });
            treeViewController.setOnGetLabel(treeItem -> {
                final AbstractEntity entity = treeItem.getValue();
                if (entity == null)
                    return null;
                else if (entity instanceof BaseParaBD)
                    return ((BaseParaBD) entity).buildLabel(false);
                else if (entity instanceof AlbumLite && repertoireGroup.getValue() == TypeRepertoireAlbumEntry.PAR_SERIE)
                    return ((AlbumLite) entity).buildLabel(false);
                else
                    return entity.buildLabel();
            });
        }

        infoTabAlbums.daoClassProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                infoTabAlbums.getTreeViewController().refresh();
        });

        repertoireGroup.getItems().addAll(TypeRepertoireAlbumEntry.values());
        repertoireGroup.setValue(TypeRepertoireAlbumEntry.PAR_SERIE);
        repertoireGroup.valueProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                infoTabAlbums.setDaoClass(newValue.daoClass);
        });

        currentInfoTab.addListener((observable, oldValue, newValue) -> {
            if (newValue != null) {
                final TreeTableView<AbstractEntity> treeView = newValue.getTreeViewController().getTreeView();
                if (treeView.getRoot() == null)
                    refresh();
            }
        });

        // on se fiche du tab, il doit juste être différent de tabAlbums
        tabs.getSelectionModel().select(tabSeries);
        tabs.getSelectionModel().selectedItemProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                currentInfoTab.set(tabView.get(newValue.getId()));
        });
        tabs.getSelectionModel().select(tabAlbums);
    }

    public void refresh() {
        currentInfoTab.getValue().getTreeViewController().refresh();
    }

    private enum TypeRepertoireAlbumEntry {
        PAR_TITRE(I18nSupport.message("Titre"), AlbumLiteDao.class),
        PAR_SERIE(I18nSupport.message("Série"), AlbumLiteSerieDao.class),
        PAR_EDITEUR(I18nSupport.message("Editeur"), AlbumLiteEditeurDao.class),
        PAR_GENRE(I18nSupport.message("Genre"), AlbumLiteGenreDao.class),
        PAR_ANNEE(I18nSupport.message("Annee.de.parution"), AlbumLiteAnneeDao.class),
        PAR_COLLECTION(I18nSupport.message("Collection"), AlbumLiteCollectionDao.class);

        String label;

        Class<? extends RepertoireLiteDao> daoClass;

        TypeRepertoireAlbumEntry(String label, Class<? extends RepertoireLiteDao> daoClass) {
            this.label = label;
            this.daoClass = daoClass;
        }

        public String toString() {
            return label;
        }

    }

    @SuppressWarnings("UnusedDeclaration")
    private class InfoTab {
        private final ObjectProperty<Tab> tab = new SimpleObjectProperty<>(this, "tab", null);
        private final ObjectProperty<Class<? extends RepertoireLiteDao>> daoClass = new SimpleObjectProperty<>(this, "daoClass", null);
        private final ObjectProperty<TreeViewController> treeViewController = new SimpleObjectProperty<>(this, "treeViewController", null);
        private final ObjectProperty<RepertoireLiteDao> dao = new SimpleObjectProperty<>(this, "dao", null);

        public InfoTab(Tab tab, Class<? extends RepertoireLiteDao> daoClass, TreeViewController treeViewController) {
            dao.bind(Bindings.createObjectBinding(() -> SpringContext.CONTEXT.getBean(getDaoClass()), this.daoClass));
            setTab(tab);
            setDaoClass(daoClass);
            setTreeViewController(treeViewController);
        }

        public Tab getTab() {
            return tab.get();
        }

        public void setTab(Tab tab) {
            this.tab.set(tab);
        }

        public ObjectProperty<Tab> tabProperty() {
            return tab;
        }

        public Class<? extends RepertoireLiteDao> getDaoClass() {
            return daoClass.get();
        }

        public void setDaoClass(Class<? extends RepertoireLiteDao> daoClass) {
            this.daoClass.set(daoClass);
        }

        public ObjectProperty<Class<? extends RepertoireLiteDao>> daoClassProperty() {
            return daoClass;
        }

        public TreeViewController getTreeViewController() {
            return treeViewController.get();
        }

        public void setTreeViewController(TreeViewController treeViewController) {
            this.treeViewController.set(treeViewController);
        }

        public ObjectProperty<TreeViewController> treeViewControllerProperty() {
            return treeViewController;
        }

        public RepertoireLiteDao getDao() {
            return dao.get();
        }

        private void setDao(RepertoireLiteDao dao) {
            this.dao.set(dao);
        }

        public ObjectProperty<RepertoireLiteDao> daoProperty() {
            return dao;
        }
    }

}
