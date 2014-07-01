/**
 * Sample Skeleton for 'repertoire.fxml' Controller Class
 */

package org.tetram.bdtheque.gui.controllers;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.SpringContext;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.AbstractEntity;
import org.tetram.bdtheque.data.bean.EvaluatedEntity;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.dao.*;
import org.tetram.bdtheque.data.dao.mappers.XMLFile;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.utils.InitialeEntity;
import org.tetram.bdtheque.gui.utils.NotationResource;
import org.tetram.bdtheque.utils.I18nSupport;

import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.ResourceBundle;

@Controller
@XMLFile("/org/tetram/bdtheque/gui/repertoire.fxml")
public class RepertoireController extends WindowController {

    @FXML
    private ResourceBundle resources;
    @FXML
    private URL location;

    @FXML
    private TabPane tabs;

    @FXML
    private Tab tabAlbums;
    @FXML
    private TreeView<AbstractEntity> tvAlbums;
    @FXML
    private ChoiceBox<TypeRepertoireAlbumEntry> repertoireGroup;

    @FXML
    private Tab tabSeries;
    @FXML
    private TreeView<AbstractEntity> tvSeries;

    @FXML
    private Tab tabUnivers;
    @FXML
    private TreeView<AbstractEntity> tvUnivers;

    @FXML
    private Tab tabAuteurs;
    @FXML
    private TreeView<AbstractEntity> tvAuteurs;

    @FXML
    private Tab tabParabd;
    @FXML
    private TreeView<AbstractEntity> tvParabd;
    @Autowired
    private ParaBDLiteDao paraBDLiteDao;

    @Autowired
    private UserPreferences userPreferences;

    private ObjectProperty<AbstractDBEntity> selectedEntity = new SimpleObjectProperty<>();
    private ObjectProperty<InfoTab> currentInfoTab = new SimpleObjectProperty<>();

    @FXML
    void initialize() {
        HashMap<Tab, InfoTab> tabView = new HashMap<>();
        final InfoTab infoTabAlbums = new InfoTab(tabAlbums, tvAlbums, TypeRepertoireAlbumEntry.PAR_SERIE.daoClass);
        tabView.put(tabAlbums, infoTabAlbums);
        tabView.put(tabSeries, new InfoTab(tabSeries, tvSeries, SerieLiteDao.class));
        tabView.put(tabUnivers, new InfoTab(tabUnivers, tvUnivers, UniversLiteDao.class));
        tabView.put(tabAuteurs, new InfoTab(tabAuteurs, tvAuteurs, PersonneLiteDao.class));
        tabView.put(tabParabd, new InfoTab(tabParabd, tvParabd, ParaBDLiteDao.class));

        final EventHandler<MouseEvent> onMouseClicked = new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent event) {
                if (event.getClickCount() == 2) {
                    final AbstractEntity selectedItem = currentInfoTab.get().getTreeView().getSelectionModel().getSelectedItem().getValue();
                    if (selectedItem instanceof AbstractDBEntity)
                        selectedEntity.set(((AbstractDBEntity) selectedItem));
                }
            }
        };

        for (InfoTab infoTab : tabView.values())
            infoTab.getTreeView().setOnMouseClicked(onMouseClicked);

        infoTabAlbums.daoClassProperty().addListener(new ChangeListener<Class<? extends RepertoireLiteDao>>() {
            @Override
            public void changed(ObservableValue<? extends Class<? extends RepertoireLiteDao>> observable, Class<? extends RepertoireLiteDao> oldValue, Class<? extends RepertoireLiteDao> newValue) {
                if (newValue != null)
                    infoTabAlbums.getTreeView().setRoot(new InitialTreeItem(SpringContext.CONTEXT.getBean(newValue)));
            }
        });

        repertoireGroup.getItems().addAll(TypeRepertoireAlbumEntry.values());
        repertoireGroup.setValue(TypeRepertoireAlbumEntry.PAR_SERIE);
        repertoireGroup.valueProperty().addListener(new ChangeListener<TypeRepertoireAlbumEntry>() {
            @Override
            public void changed(ObservableValue<? extends TypeRepertoireAlbumEntry> observable, TypeRepertoireAlbumEntry oldValue, TypeRepertoireAlbumEntry newValue) {
                if (newValue != null)
                    infoTabAlbums.setDaoClass(newValue.daoClass);
            }
        });

        currentInfoTab.addListener(new ChangeListener<InfoTab>() {
            @Override
            public void changed(ObservableValue<? extends InfoTab> observable, InfoTab oldValue, InfoTab newValue) {
                if (newValue != null) {
                    final InitialTreeItem root = (InitialTreeItem) newValue.getTreeView().getRoot();
                    if (root == null || !newValue.getDaoClass().isInstance(root.dao))
                        refresh();
                }
            }
        });

        // on se fiche du tab, il doit juste être différent de tabAlbums
        tabs.getSelectionModel().select(tabSeries);
        tabs.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<Tab>() {
            @Override
            public void changed(ObservableValue<? extends Tab> observable, Tab oldValue, Tab newValue) {
                if (newValue != null)
                    currentInfoTab.set(tabView.get(newValue));
            }
        });
        tabs.getSelectionModel().select(tabAlbums);
    }

    public void refresh() {
        final InfoTab infoTab = currentInfoTab.getValue();
        infoTab.getTreeView().setRoot(new InitialTreeItem(SpringContext.CONTEXT.getBean(infoTab.getDaoClass())));
    }

    public AbstractDBEntity getSelectedEntity() {
        return selectedEntity.get();
    }

    public ObjectProperty<AbstractDBEntity> selectedEntityProperty() {
        return selectedEntity;
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
        private ObjectProperty<Tab> tab = new SimpleObjectProperty<>();
        private ObjectProperty<TreeView<AbstractEntity>> treeView = new SimpleObjectProperty<>();
        private ObjectProperty<Class<? extends RepertoireLiteDao>> daoClass = new SimpleObjectProperty<>();

        private InfoTab(Tab tab, TreeView<AbstractEntity> treeView, Class<? extends RepertoireLiteDao> daoClass) {
            setTab(tab);
            setTreeView(treeView);
            setDaoClass(daoClass);
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

        public TreeView<AbstractEntity> getTreeView() {
            return treeView.get();
        }

        public void setTreeView(TreeView<AbstractEntity> treeView) {
            this.treeView.set(treeView);
        }

        public ObjectProperty<TreeView<AbstractEntity>> treeViewProperty() {
            return treeView;
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
    }

    private class InitialTreeItem extends TreeItem<AbstractEntity> {
        private final RepertoireLiteDao dao;
        private boolean isLeaf;
        private boolean isFirstTimeChildren = true;
        private boolean isFirstTimeLeaf = true;

        public InitialTreeItem(RepertoireLiteDao dao) {
            this(dao, null);
        }

        public InitialTreeItem(RepertoireLiteDao dao, AbstractEntity value) {
            super(value);
            this.dao = dao;
            if (userPreferences.isAfficheNoteListes() && value instanceof EvaluatedEntity) {
                final ValeurListe notation = ((EvaluatedEntity) value).getNotation();
                final NotationResource resource = NotationResource.fromValue(notation.getValeur());
                if (notation.getValeur() > 900 && resource != null)
                    this.setGraphic(new ImageView("/org/tetram/bdtheque/graphics/png/16x16/" + resource.getResource()));
            }
        }

        @Override
        public ObservableList<TreeItem<AbstractEntity>> getChildren() {
            if (isFirstTimeChildren) {
                isFirstTimeChildren = false;
                super.getChildren().setAll(buildChildren(this));
            }
            return super.getChildren();
        }

        @Override
        public boolean isLeaf() {
            if (isFirstTimeLeaf) {
                isFirstTimeLeaf = false;
                isLeaf = getValue() instanceof AbstractDBEntity;
            }
            return isLeaf;
        }

        @SuppressWarnings("unchecked")
        private ObservableList<InitialTreeItem> buildChildren(InitialTreeItem treeItem) {
            List<? extends AbstractEntity> items;
            if (treeItem.getParent() == null)
                items = dao.getInitiales(null);
            else
                items = dao.getListEntitiesByInitiale((InitialeEntity) treeItem.getValue(), null);

            ObservableList<InitialTreeItem> children = FXCollections.observableArrayList();
            if (items != null) {
                for (AbstractEntity item : items) children.add(new InitialTreeItem(dao, item));
                return children;
            }

            return FXCollections.emptyObservableList();
        }

    }
}
