/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * TreeViewController.java
 * Last modified by Tetram, on 2014-07-29T17:58:50CEST
 */

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
import javafx.scene.input.KeyCode;
import javafx.scene.input.MouseEvent;
import javafx.util.Callback;
import javafx.util.Duration;
import jfxtras.animation.Timer;
import org.apache.commons.collections4.map.ListOrderedMap;
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
import org.tetram.bdtheque.gui.controllers.ApplicationMode;
import org.tetram.bdtheque.gui.controllers.MainController;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.utils.History;
import org.tetram.bdtheque.gui.utils.NotationResource;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 09/07/2014.
 */

@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/components/treeview.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/components/treeview.css")
})
public class TreeViewController extends WindowController {

    @NonNls
    private static final String NODE_BOLD_CSS = "node-bold";
    private final Timer searchTimer = new Timer(this::registerFind);
    private final BooleanProperty clickToShow = new SimpleBooleanProperty(this, "clickToShow", true);
    private final ObjectProperty<EventHandler<MouseEvent>> onClickItem = new SimpleObjectProperty<>(this, "onClickItem", null);
    private final ObjectProperty<Callback<TreeViewNode, List<? extends AbstractEntity>>> onGetChildren = new SimpleObjectProperty<>(this, "onGetChildren", null);
    private final ObjectProperty<Callback<TreeViewNode, Boolean>> onIsLeaf = new SimpleObjectProperty<>(this, "onIsLeaf", null);
    private final ObjectProperty<Callback<AbstractEntity, String>> onGetLabel = new SimpleObjectProperty<>(this, "onGetLabel", null);
    private final ObjectProperty<Class<? extends AbstractEntity>> finalEntityClass = new SimpleObjectProperty<>(this, "finalEntityClass", AbstractEntity.class);
    private final ReadOnlyStringWrapper appliedFiltre = new ReadOnlyStringWrapper(this, "appliedFiltre", null);
    private final StringProperty filtre = new SimpleStringProperty(this, "filtre", null);
    private final BooleanProperty useDefaultFiltre = new SimpleBooleanProperty(this, "useDefaultFiltre", true);
    private final ReadOnlyObjectWrapper<RepertoireLiteDao<?, ?>> dao = new ReadOnlyObjectWrapper<>(this, "dao", null);
    private final ObjectProperty<TreeViewMode> mode = new SimpleObjectProperty<>(this, "mode", TreeViewMode.NONE);
    private final ObjectProperty<AbstractEntity> selectedEntity = new SimpleObjectProperty<>(this, "selectedEntity", null);
    private final BooleanProperty canSearch = new SimpleBooleanProperty(this, "canSearch", true);
    @Autowired
    private History history;
    @Autowired
    private UserPreferences userPreferences;
    @Autowired
    private MainController mainController;
    @FXML
    private TreeTableView<AbstractEntity> treeTableView;
    @FXML
    private TreeTableColumn<AbstractEntity, AbstractEntity> column0;
    @FXML
    private TreeTableColumn<AbstractEntity, AbstractEntity> column1;
    @FXML
    private TextField tfSearch;
    private boolean findRegistered = false;
    private String lastFindText;
    private ListOrderedMap<? extends InitialeEntity<? extends Comparable<?>>, ? extends List<? extends AbstractDBEntity>> findList;

    public TreeViewController() {
        searchTimer.setRepeats(false);
        searchTimer.setDelay(new Duration(800));
    }

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

        tfSearch.visibleProperty().bind(canSearchProperty());
        tfSearch.textProperty().addListener(o -> searchTimer.restart());
        tfSearch.setOnKeyReleased(event -> {
            if (event.getCode().equals(KeyCode.F3)) find(true);
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
                        if (mainController.getMode() == ApplicationMode.CONSULTATION)
                            history.addWaiting(History.HistoryAction.FICHE, (AbstractDBEntity) entity);
                        else
                            history.addWaiting(History.HistoryAction.GESTION_MODIF, (AbstractDBEntity) entity);
                }
            }
        };

        treeTableView.onMouseClickedProperty().bind(Bindings.createObjectBinding(() -> {
            if (getClickToShow() && getOnClickItem() == null)
                return onMouseClicked;
            else
                return getOnClickItem();
        }, clickToShowProperty(), onClickItemProperty()));

        column0.setCellValueFactory(param -> param.getValue().valueProperty());
        column0.setCellFactory(param -> new Column0Cell());

        column1.setCellValueFactory(param -> param.getValue().valueProperty());
        column1.setCellFactory(param -> new Column1Cell());

        final BooleanBinding finalEntityClassIsEvaluated = Bindings.createBooleanBinding(() -> EvaluatedEntity.class.isAssignableFrom(getFinalEntityClass()), finalEntityClass);
        final BooleanBinding column1Visible = Bindings.and(userPreferences.afficheNoteListesProperty(), finalEntityClassIsEvaluated);
        column1.visibleProperty().bind(column1Visible);

        treeTableView.getSelectionModel().selectedItemProperty().addListener((observable, oldEntity, newEntity) -> {
            TreeViewNode treeViewNode = (TreeViewNode) newEntity;
            // ne surtout pas utiliser setSelectedEntity
            selectedEntity.set(treeViewNode != null && treeViewNode.isLeaf() ? treeViewNode.getValue() : null);
        });

        Platform.runLater(this::refresh);
    }

    private String getLabelForItem(AbstractEntity entity) {
        String label;
        if (getOnGetLabel() != null)
            label = entity == null ? "" : getOnGetLabel().call(entity);
        else {
            label = entity == null ? "" : entity.buildLabel();
        }
        return label;
    }

    private synchronized void registerFind() {
        if (!findRegistered) {
            Platform.runLater(() -> {
                findRegistered = false;
                find(tfSearch.getText());
            });
            findRegistered = true;
        }
    }

    public void find(String text) {
        find(text, false);
    }

    public void find(boolean next) {
        find(lastFindText, next);
    }

    //@SuppressWarnings("unchecked")
    public void find(String text, boolean next) {
        text = text == null ? "" : text;
        next = next && text.equalsIgnoreCase(lastFindText);
        lastFindText = text;

        if (getMode() == TreeViewMode.NONE) {
            TreeViewNode nCurrent = null;
            if (next) nCurrent = getSelected();
            if (nCurrent == null) nCurrent = getFirst();

            TreeViewNode nFind = null;
            while (nFind != nCurrent) {
                if (nFind == null)
                    if (next)
                        nFind = getNext(nCurrent);
                    else
                        nFind = nCurrent;
                if (org.apache.commons.lang3.StringUtils.containsIgnoreCase(getLabelForItem(nFind.getValue()), text))
                    break;
                nFind = getNext(nFind);
                if (nFind == null)
                    nFind = getFirst();
            }
            selectNode(nFind);
        } else {
            if (StringUtils.isNullOrEmpty(text)) {
                setSelectedEntity(null, null);
                findList.clear();
            } else if (next && !findList.isEmpty()) {
                AbstractEntity current = getSelectedEntity();
                if (current == null) {
                    setSelectedEntity(findList.firstKey(), findList.get(findList.firstKey()).get(0));
                } else if (current instanceof InitialeEntity) {
                    final List<? extends AbstractEntity> list = findList.get(current);
                    if (list == null) {
                        setSelectedEntity(findList.firstKey(), findList.get(findList.firstKey()).get(0));
                    } else
                        setSelectedEntity((InitialeEntity) current, list.get(0));
                } else {
                    AbstractEntity initialeEntity = getSelected().getParent().getValue();
                    assert initialeEntity instanceof InitialeEntity;
                    final List<? extends AbstractEntity> list = findList.get(initialeEntity);
                    int i = list.indexOf(current);
                    if (i == list.size() - 1) {
                        initialeEntity = findList.nextKey(initialeEntity);
                        if (initialeEntity == null) initialeEntity = findList.firstKey();
                        current = findList.get(initialeEntity).get(0);
                    } else
                        current = list.get(i + 1);
                    setSelectedEntity((InitialeEntity) initialeEntity, current);
                }
            } else {
                findList = getDao().searchMap(text, getAppliedFiltre());
/*
          SQL.Text := 'SELECT ' + vmModeInfos[FMode].REFFIELDS + ' FROM ' + vmModeInfos[FMode].TABLESEARCH + ' WHERE ' + vmModeInfos[FMode].FIELDSEARCH +
            ' LIKE ''%'' || ? || ''%''';
          if FUseFiltre then
            SQL.Add('AND ' + FFiltre)
          else if FUseDefaultFiltre and (vmModeInfos[FMode].DEFAULTFILTRE <> '') then
            SQL.Add('AND ' + vmModeInfos[FMode].DEFAULTFILTRE);
          SQL.Add('ORDER BY ' + vmModeInfos[FMode].INITIALEFIELDS + ',');
          if vmModeInfos[FMode].SEARCHORDER <> '' then
            SQL.Add(vmModeInfos[FMode].SEARCHORDER + ',');
          SQL.Add(vmModeInfos[FMode].FIELDSEARCH);
          Prepare(True);
          Params.AsString[0] := Copy(UpperCase(SansAccents(Text)), 1, Params.MaxStrLen[0] - 2);

          Open;
*/
                if (findList.isEmpty())
                    getTreeView().getSelectionModel().clearSelection();
                else {
                    setSelectedEntity(findList.firstKey(), findList.get(findList.firstKey()).get(0));
                }
            }
        }
    }

    private TreeViewNode getNext(TreeViewNode node) {
        if (!node.isLeaf() && !node.getChildren().isEmpty())
            return (TreeViewNode) node.getChildren().get(0);
        else {
            final TreeItem<AbstractEntity> root = getTreeView().getRoot();

            TreeItem<AbstractEntity> parentNode = node.getParent();
            TreeItem<AbstractEntity> newNode = node.nextSibling();
            while (newNode == null && !parentNode.equals(root)) {
                newNode = parentNode.nextSibling();
                parentNode = parentNode.getParent();
            }
            return (TreeViewNode) newNode;
        }
    }

    private TreeViewNode getFirst() {
        return (TreeViewNode) getTreeView().getRoot().getChildren().get(0);
    }

    private TreeViewNode getSelected() {
        return (TreeViewNode) getTreeView().getSelectionModel().getSelectedItem();
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

    public Callback<AbstractEntity, String> getOnGetLabel() {
        return onGetLabel.get();
    }

    public void setOnGetLabel(Callback<AbstractEntity, String> onGetLabel) {
        this.onGetLabel.set(onGetLabel);
    }

    public ObjectProperty<Callback<AbstractEntity, String>> onGetLabelProperty() {
        return onGetLabel;
    }

    public TreeTableView<AbstractEntity> getTreeView() {
        return treeTableView;
    }

    public TreeTableColumn<AbstractEntity, AbstractEntity> getColumn0() {
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

    public RepertoireLiteDao<?, ?> getDao() {
        return dao.get();
    }

    public ReadOnlyObjectProperty<RepertoireLiteDao<?, ?>> daoProperty() {
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

    public AbstractEntity getSelectedEntity() {
        return selectedEntity.get();
    }

    private void setSelectedEntity(InitialeEntity initialeEntity, AbstractEntity selectedEntity) {
        // c'est le listener sur selectedItemProperty qui va faire le set
        // this.selectedEntity.set(selectedEntity);
        TreeViewNode node = (TreeViewNode) getTreeView().getRoot().getChildren().get(0);
        while (node != null && !node.getValue().equals(initialeEntity))
            node = (TreeViewNode) node.nextSibling();
        if (node == null) return;
        node = (TreeViewNode) node.getChildren().get(0);
        while (node != null && !node.getValue().equals(selectedEntity))
            node = (TreeViewNode) node.nextSibling();

        selectNode(node);
    }

    private void selectNode(TreeViewNode node) {
        getTreeView().getSelectionModel().select(node);
        if (node != null) {
            expandTreeView(node);
            getTreeView().getFocusModel().focus(treeTableView.getRow(node), column0);
            getTreeView().scrollTo(treeTableView.getRow(node));
        }
    }


    private void expandTreeView(TreeItem selectedItem) {
        if (selectedItem != null) {
            expandTreeView(selectedItem.getParent());
            if (!selectedItem.isLeaf()) selectedItem.setExpanded(true);
        }
    }

    public ObjectProperty<AbstractEntity> selectedEntityProperty() {
        return selectedEntity;
    }

    public boolean getCanSearch() {
        return canSearch.get();
    }

    public void setCanSearch(boolean canSearch) {
        this.canSearch.set(canSearch);
    }

    public BooleanProperty canSearchProperty() {
        return canSearch;
    }

    public UUID getCurrentID() {
        return getSelectedEntity() == null ? null : ((AbstractDBEntity) getSelectedEntity()).getId();
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

    private class Column0Cell extends TreeTableCell<AbstractEntity, AbstractEntity> {
        @Override
        protected void updateItem(AbstractEntity item, boolean empty) {
            if (getItem() == item) return;

            super.updateItem(item, empty);

            setAlignment(Pos.BASELINE_LEFT);
            setContentDisplay(ContentDisplay.RIGHT);

            getStyleClass().remove(NODE_BOLD_CSS);

            if (empty) {
                setText(null);
                setGraphic(null);
            } else {
                setText(getLabelForItem(item));

                if (item instanceof InitialeEntity) {
                    getStyleClass().add(NODE_BOLD_CSS);
                    int count = ((InitialeEntity) item).getCount();
                    if (count > 0) {
                        @NonNls final Label text = new Label("(" + count + ")");
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
    }

    private class Column1Cell extends TreeTableCell<AbstractEntity, AbstractEntity> {
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
}
