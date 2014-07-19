package org.tetram.bdtheque.gui.controllers.components;

import javafx.application.Platform;
import javafx.beans.binding.Bindings;
import javafx.beans.binding.BooleanBinding;
import javafx.beans.property.*;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.geometry.Pos;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.util.Callback;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.bean.interfaces.EvaluatedEntity;
import org.tetram.bdtheque.data.dao.RepertoireLiteDao;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.utils.History;
import org.tetram.bdtheque.gui.utils.NotationResource;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

/**
 * Created by Thierry on 09/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/components/treeview.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/components/treeview.css")
})
public class TreeViewController extends WindowController {

    @NonNls
    private static final String NODE_BOLD_CSS = "node-bold";
    @Autowired
    private History history;

    @Autowired
    private UserPreferences userPreferences;

    @FXML
    private TreeTableView<AbstractEntity> treeTableView;

    @FXML
    private TreeTableColumn<AbstractEntity, String> column0;
    @FXML
    private TreeTableColumn<AbstractEntity, AbstractEntity> column1;

    private BooleanProperty clickToShow = new SimpleBooleanProperty(this, "clickToShow", true);
    private ObjectProperty<EventHandler<MouseEvent>> onClickItem = new SimpleObjectProperty<>(this, "onClickItem", null);
    private ObjectProperty<Callback<TreeViewNode, List<? extends AbstractEntity>>> onGetChildren = new SimpleObjectProperty<>(this, "onGetChildren", null);
    private ObjectProperty<Callback<TreeViewNode, Boolean>> onIsLeaf = new SimpleObjectProperty<>(this, "onIsLeaf", null);
    private ObjectProperty<Callback<TreeViewNode, String>> onGetLabel = new SimpleObjectProperty<>(this, "onGetLabel", null);
    private ObjectProperty<Class<? extends AbstractEntity>> finalEntityClass = new SimpleObjectProperty<>(this, "finalEntityClass", AbstractEntity.class);

    private ReadOnlyStringWrapper appliedFiltre = new ReadOnlyStringWrapper(this, "appliedFiltre", null);
    private StringProperty filtre = new SimpleStringProperty(this, "filtre", null);
    private BooleanProperty useDefaultFiltre = new SimpleBooleanProperty(this, "useDefaultFiltre", true);
    private ReadOnlyObjectWrapper<RepertoireLiteDao> dao = new ReadOnlyObjectWrapper<>(this, "dao", null);
    private ObjectProperty<TreeViewMode> mode = new SimpleObjectProperty<>(this, "mode", TreeViewMode.NONE);

    @FXML
    public void initialize() {
        mode.addListener(observable -> {
            final TreeViewMode newMode = getMode() == null ? TreeViewMode.NONE : getMode();
            finalEntityClass.set(newMode == TreeViewMode.NONE ? AbstractEntity.class : newMode.getEntityClass());
            onGetLabel.set(newMode == TreeViewMode.NONE ? null : new TreeViewMode.GetLabelCallback(this));
            onGetChildren.set(newMode == TreeViewMode.NONE ? null : new TreeViewMode.GetChildrenCallback(this));
            dao.set(newMode == TreeViewMode.NONE ? null : SpringContext.CONTEXT.getBean(newMode.getDaoClass()));
            refresh();
        });

        appliedFiltre.bind(Bindings.createStringBinding(() -> {
            String s = getFiltre();
            if (!StringUtils.isNullOrEmpty(s)) return s;
            if (getUseDefaultFiltre()) return getMode().getDefaultFiltre();
            return null;
        }, filtreProperty()));

        treeTableView.setPlaceholder(new Label(I18nSupport.message("pas.de.donnees.a.afficher")));

        final EventHandler<MouseEvent> onMouseClicked = event -> {
            if (event.getClickCount() == 2) {
                final TreeItem<AbstractEntity> selectedItem = treeTableView.getSelectionModel().getSelectedItem();
                if (selectedItem != null && selectedItem.isLeaf()) {
                    final AbstractEntity entity = selectedItem.getValue();
                    if (entity != null && entity instanceof AbstractDBEntity)
                        history.addWaiting(History.HistoryAction.FICHE, (AbstractDBEntity) entity);
                }
            }
        };

        treeTableView.onMouseClickedProperty().bind(Bindings.createObjectBinding(() -> {
            if (getClickToShow() && getOnClickItem() == null)
                return onMouseClicked;
            else
                return getOnClickItem();
        }, clickToShowProperty(), onClickItemProperty()));

        column0.setCellValueFactory(param -> {
            final TreeItem<AbstractEntity> treeViewNode = param.getValue();
            String label;
            if (getOnGetLabel() != null)
                label = treeViewNode == null ? "" : getOnGetLabel().call((TreeViewNode) treeViewNode);
            else {
                final AbstractEntity entity = treeViewNode == null ? null : treeViewNode.getValue();
                label = entity == null ? "" : entity.buildLabel();
            }
            // l'appel à new String() est peut être redondant mais sans ça, le treeTableView ne fonctionne pas correctement
            //noinspection RedundantStringConstructorCall
            return new ReadOnlyStringWrapper(new String(label));
        });
        column0.setCellFactory(param ->
                        new TreeTableCell<AbstractEntity, String>() {
                            @Override
                            protected void updateItem(String item, boolean empty) {
                                super.updateItem(item, empty);

                                final TreeItem<AbstractEntity> treeItem = getTreeTableRow().getTreeItem();
                                if (treeItem != null && treeItem.getParent() != null && treeItem.getParent().equals(treeTableView.getRoot()))
                                    getStyleClass().add(NODE_BOLD_CSS);
                                else
                                    getStyleClass().remove(NODE_BOLD_CSS);

                                setAlignment(Pos.BASELINE_LEFT);
                                setContentDisplay(ContentDisplay.RIGHT);

                                if (empty) {
                                    setText(null);
                                    setGraphic(null);
                                } else {
                                    setText(item);
                                    AbstractEntity entity = treeItem == null ? null : treeItem.getValue();
                                    if (entity instanceof InitialeEntity && ((InitialeEntity) entity).getCount() > 0) {
                                        @NonNls final Label text = new Label("(" + ((InitialeEntity) entity).getCount() + ")");
                                        text.setStyle("-fx-font-weight: normal;");
                                        text.setAlignment(Pos.BASELINE_CENTER);
                                        setGraphicTextGap(8);
                                        setGraphic(text);
                                    } else {
                                        setGraphic(null);
                                    }
                                }
                            }
                        }
        );

        column1.setCellValueFactory(param ->
                        new ReadOnlyObjectWrapper<>(param.getValue().getValue())
        );
        column1.setCellFactory(param ->
                        new TreeTableCell<AbstractEntity, AbstractEntity>() {
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
                        }
        );

        final BooleanBinding finalEntityClassIsEvaluated = Bindings.createBooleanBinding(() -> EvaluatedEntity.class.isAssignableFrom(getFinalEntityClass()), finalEntityClass);
        final BooleanBinding column1Visible = Bindings.and(userPreferences.afficheNoteListesProperty(), finalEntityClassIsEvaluated);
        column1.visibleProperty().bind(column1Visible);

        Platform.runLater(this::refresh);
    }

    public boolean getClickToShow() {
        return clickToShow.get();
    }

    public void setClickToShow(boolean clickToShow) {
        this.clickToShow.set(clickToShow);
    }

    public BooleanProperty clickToShowProperty() {
        return clickToShow;
    }

    public EventHandler<MouseEvent> getOnClickItem() {
        return onClickItem.get();
    }

    public void setOnClickItem(EventHandler<MouseEvent> onClickItem) {
        this.onClickItem.set(onClickItem);
    }

    public ObjectProperty<EventHandler<MouseEvent>> onClickItemProperty() {
        return onClickItem;
    }

    public Callback<TreeViewNode, List<? extends AbstractEntity>> getOnGetChildren() {
        return onGetChildren.get();
    }

    public void setOnGetChildren(Callback<TreeViewNode, List<? extends AbstractEntity>> onGetChildren) {
        this.onGetChildren.set(onGetChildren);
    }

    public ObjectProperty<Callback<TreeViewNode, List<? extends AbstractEntity>>> onGetChildrenProperty() {
        return onGetChildren;
    }

    public Callback<TreeViewNode, Boolean> getOnIsLeaf() {
        return onIsLeaf.get();
    }

    public void setOnIsLeaf(Callback<TreeViewNode, Boolean> onIsLeaf) {
        this.onIsLeaf.set(onIsLeaf);
    }

    public ObjectProperty<Callback<TreeViewNode, Boolean>> onIsLeafProperty() {
        return onIsLeaf;
    }

    public Callback<TreeViewNode, String> getOnGetLabel() {
        return onGetLabel.get();
    }

    public void setOnGetLabel(Callback<TreeViewNode, String> onGetLabel) {
        this.onGetLabel.set(onGetLabel);
    }

    public ObjectProperty<Callback<TreeViewNode, String>> onGetLabelProperty() {
        return onGetLabel;
    }

    public TreeTableView<AbstractEntity> getTreeView() {
        return treeTableView;
    }

    public TreeTableColumn<AbstractEntity, String> getColumn0() {
        return column0;
    }

    public TreeTableColumn<AbstractEntity, AbstractEntity> getColumn1() {
        return column1;
    }

    public ObjectProperty<Class<? extends AbstractEntity>> finalEntityClassProperty() {
        return finalEntityClass;
    }

    public Class<? extends AbstractEntity> getFinalEntityClass() {
        return finalEntityClass.get();
    }

    public void setFinalEntityClass(Class<? extends AbstractEntity> finalEntityClass) {
        this.finalEntityClass.set(finalEntityClass);
    }

    public void refresh() {
        treeTableView.setRoot(new TreeViewNode(null));
    }

    public TreeViewMode getMode() {
        return mode.get();
    }

    public void setMode(TreeViewMode mode) {
        this.mode.set(mode);
    }

    public ObjectProperty<TreeViewMode> modeProperty() {
        return mode;
    }

    public String getFiltre() {
        return filtre.get();
    }

    public void setFiltre(String filtre) {
        this.filtre.set(filtre);
    }

    public StringProperty filtreProperty() {
        return filtre;
    }

    public String getAppliedFiltre() {
        return appliedFiltre.get();
    }

    public ReadOnlyStringProperty appliedFiltreProperty() {
        return appliedFiltre.getReadOnlyProperty();
    }

    public RepertoireLiteDao getDao() {
        return dao.get();
    }

    public ReadOnlyObjectProperty<RepertoireLiteDao> daoProperty() {
        return dao.getReadOnlyProperty();
    }

    public boolean getUseDefaultFiltre() {
        return useDefaultFiltre.get();
    }

    public void setUseDefaultFiltre(boolean useDefaultFiltre) {
        this.useDefaultFiltre.set(useDefaultFiltre);
    }

    public BooleanProperty useDefaultFiltreProperty() {
        return useDefaultFiltre;
    }

    public class TreeViewNode extends TreeItem<AbstractEntity> {
        private boolean isLeaf;
        private boolean isFirstTimeChildren = true;
        private boolean isFirstTimeLeaf = true;

        private TreeViewNode(AbstractEntity value) {
            super(value);
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
                isLeaf = getOnIsLeaf() == null ? (this.getValue() != null && !(this.getValue() instanceof InitialeEntity)) : getOnIsLeaf().call(this);
            }
            return isLeaf;
        }

        @SuppressWarnings("unchecked")
        private ObservableList<TreeViewNode> buildChildren(TreeViewNode treeItem) {
            final Callback<TreeViewNode, List<? extends AbstractEntity>> getChildren = TreeViewController.this.getOnGetChildren();
            if (getChildren != null) {
                List<? extends AbstractEntity> childrenEntities = getChildren.call(treeItem);

                if (childrenEntities != null && !childrenEntities.isEmpty()) {
                    ObservableList<TreeViewNode> children = FXCollections.observableArrayList();
                    for (AbstractEntity item : childrenEntities) children.add(new TreeViewNode(item));
                    return children;
                }
            }
            return FXCollections.emptyObservableList();
        }

    }

}
