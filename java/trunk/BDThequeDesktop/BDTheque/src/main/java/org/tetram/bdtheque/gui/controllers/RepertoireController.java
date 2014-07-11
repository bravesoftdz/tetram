/**
 * Sample Skeleton for 'repertoire.fxml' Controller Class
 */

package org.tetram.bdtheque.gui.controllers;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyObjectWrapper;
import javafx.beans.property.ReadOnlyStringWrapper;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.util.Callback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.bean.interfaces.EvaluatedEntity;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.dao.*;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.utils.InitialeEntity;
import org.tetram.bdtheque.gui.utils.NotationResource;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.HashMap;
import java.util.List;

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
    private TreeTableView<AbstractEntity> tvAlbums;
    @FXML
    private ChoiceBox<TypeRepertoireAlbumEntry> repertoireGroup;

    @FXML
    private Tab tabSeries;
    @FXML
    private TreeTableView<AbstractEntity> tvSeries;

    @FXML
    private Tab tabUnivers;
    @FXML
    private TreeTableView<AbstractEntity> tvUnivers;

    @FXML
    private Tab tabAuteurs;
    @FXML
    private TreeTableView<AbstractEntity> tvAuteurs;

    @FXML
    private Tab tabParabd;
    @FXML
    private TreeTableView<AbstractEntity> tvParabd;
    @Autowired
    private ParaBDLiteDao paraBDLiteDao;

    @Autowired
    private UserPreferences userPreferences;

    private ObjectProperty<InfoTab> currentInfoTab = new SimpleObjectProperty<>();

    @SuppressWarnings("unchecked")
    @FXML
    void initialize() {
        // pourquoi ça marchait avant avec <Tab, InfoTab> et que ça ne marche plus maintenant, mystère
        HashMap<String, InfoTab> tabView = new HashMap<>();
        final InfoTab infoTabAlbums = new InfoTab(tabAlbums, tvAlbums, TypeRepertoireAlbumEntry.PAR_SERIE.daoClass);
        tabView.put(tabAlbums.getId(), infoTabAlbums);
        tabView.put(tabSeries.getId(), new InfoTab(tabSeries, tvSeries, SerieLiteDao.class));
        tabView.put(tabUnivers.getId(), new InfoTab(tabUnivers, tvUnivers, UniversLiteDao.class));
        tabView.put(tabAuteurs.getId(), new InfoTab(tabAuteurs, tvAuteurs, PersonneLiteDao.class));
        tabView.put(tabParabd.getId(), new InfoTab(tabParabd, tvParabd, ParaBDLiteDao.class));

        final Callback<TreeTableColumn.CellDataFeatures<AbstractEntity, String>, ObservableValue<String>> labelValueFactory = param -> {
            final AbstractEntity entity = param.getValue().getValue();
            if (entity instanceof AlbumLite && repertoireGroup.getValue() == TypeRepertoireAlbumEntry.PAR_SERIE)
                return new ReadOnlyStringWrapper(((AlbumLite) entity).buildLabel(false));
            else
                return new ReadOnlyStringWrapper(entity.buildLabel());
        };
        final Callback<TreeTableColumn.CellDataFeatures<AbstractEntity, AbstractEntity>, ObservableValue<AbstractEntity>> imageValueCellFactory = param -> new ReadOnlyObjectWrapper<>(param.getValue().getValue());
        final Callback<TreeTableColumn<AbstractEntity, AbstractEntity>, TreeTableCell<AbstractEntity, AbstractEntity>> imageCellFactory = new Callback<TreeTableColumn<AbstractEntity, AbstractEntity>, TreeTableCell<AbstractEntity, AbstractEntity>>() {

            @Override
            public TreeTableCell<AbstractEntity, AbstractEntity> call(TreeTableColumn<AbstractEntity, AbstractEntity> param) {
                return new TreeTableCell<AbstractEntity, AbstractEntity>() {

                    @Override
                    protected void updateItem(AbstractEntity item, boolean empty) {
                        super.updateItem(item, empty);
                        setGraphic(null);
                        if (item instanceof EvaluatedEntity) {
                            final ValeurListe notation = ((EvaluatedEntity) item).getNotation();
                            final NotationResource resource = NotationResource.fromValue(notation.getValeur());
                            if (resource != null && notation.getValeur() > 900)
                                setGraphic(new ImageView("/org/tetram/bdtheque/graphics/png/16x16/" + resource.getResource()));
                        }
                    }
                };
            }
        };

        final EventHandler<MouseEvent> onMouseClicked = event -> {
            if (event.getClickCount() == 2) {
                final AbstractEntity entity = currentInfoTab.get().getTreeView().getSelectionModel().getSelectedItem().getValue();
                if (entity != null && entity instanceof AbstractDBEntity)
                    modeConsultationController.showConsultationForm((AbstractDBEntity) entity);
            }
        };

        for (InfoTab infoTab : tabView.values()) {
            infoTab.getTreeView().setOnMouseClicked(onMouseClicked);
            ((TreeTableColumn<AbstractEntity, String>) infoTab.getTreeView().getColumns().get(0)).setCellValueFactory(labelValueFactory);
            if (infoTab.getTreeView().getColumns().size() > 1) {
                final TreeTableColumn<AbstractEntity, AbstractEntity> column = (TreeTableColumn<AbstractEntity, AbstractEntity>) infoTab.getTreeView().getColumns().get(1);
                column.setCellValueFactory(imageValueCellFactory);
                column.setCellFactory(imageCellFactory);
                column.visibleProperty().bind(userPreferences.afficheNoteListesProperty());
            }
        }

        infoTabAlbums.daoClassProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                infoTabAlbums.getTreeView().setRoot(new InitialTreeItem(SpringContext.CONTEXT.getBean(newValue)));
        });

        repertoireGroup.getItems().addAll(TypeRepertoireAlbumEntry.values());
        repertoireGroup.setValue(TypeRepertoireAlbumEntry.PAR_SERIE);
        repertoireGroup.valueProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                infoTabAlbums.setDaoClass(newValue.daoClass);
        });

        currentInfoTab.addListener((observable, oldValue, newValue) -> {
            if (newValue != null) {
                final InitialTreeItem root = (InitialTreeItem) newValue.getTreeView().getRoot();
                if (root == null || !newValue.getDaoClass().isInstance(root.dao))
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
        final InfoTab infoTab = currentInfoTab.getValue();
        infoTab.getTreeView().setRoot(new InitialTreeItem(SpringContext.CONTEXT.getBean(infoTab.getDaoClass())));
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
        private ObjectProperty<TreeTableView<AbstractEntity>> treeView = new SimpleObjectProperty<>();
        private ObjectProperty<Class<? extends RepertoireLiteDao>> daoClass = new SimpleObjectProperty<>();

        private InfoTab(Tab tab, TreeTableView<AbstractEntity> treeView, Class<? extends RepertoireLiteDao> daoClass) {
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

        public TreeTableView<AbstractEntity> getTreeView() {
            return treeView.get();
        }

        public void setTreeView(TreeTableView<AbstractEntity> treeView) {
            this.treeView.set(treeView);
        }

        public ObjectProperty<TreeTableView<AbstractEntity>> treeViewProperty() {
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
/*
            if (userPreferences.isAfficheNoteListes() && value instanceof EvaluatedEntity) {
                final ValeurListe notation = ((EvaluatedEntity) value).getNotation();
                final NotationResource resource = NotationResource.fromValue(notation.getValeur());
                if (notation.getValeur() > 900 && resource != null)
                    this.setGraphic(new ImageView("/org/tetram/bdtheque/graphics/png/16x16/" + resource.getResource()));
            }
             */
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
