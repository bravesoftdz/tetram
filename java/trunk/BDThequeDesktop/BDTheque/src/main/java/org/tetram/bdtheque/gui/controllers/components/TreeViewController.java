package org.tetram.bdtheque.gui.controllers.components;

import javafx.application.Platform;
import javafx.beans.NamedArg;
import javafx.beans.binding.Bindings;
import javafx.beans.property.*;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.event.EventTarget;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.util.Callback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.EvaluatedEntity;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.controllers.ModeConsultationController;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.utils.NotationResource;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

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

    @Autowired
    private ModeConsultationController modeConsultationController;

    @Autowired
    private UserPreferences userPreferences;

    @FXML
    private TreeTableView<AbstractEntity> treeview;

    @FXML
    private TreeTableColumn<AbstractEntity, String> column0;
    @FXML
    private TreeTableColumn<AbstractEntity, AbstractEntity> column1;

    private BooleanProperty clickToShow = new SimpleBooleanProperty(this, "clickToShow", true);
    private ObjectProperty<EventHandler<MouseEvent>> onClickItem = new SimpleObjectProperty<>(this, "onClickItem", null);
    private ObjectProperty<Callback<TreeViewNode, List<? extends AbstractEntity>>> onGetChildren = new SimpleObjectProperty<>(this, "onGetChildren", null);
    private ObjectProperty<Callback<TreeViewNode, Boolean>> onIsLeaf = new SimpleObjectProperty<>(this, "onIsLeaf", param -> true);
    private ObjectProperty<Callback<TreeViewNode, String>> onGetLabel = new SimpleObjectProperty<>(this, "onGetLabel", null);

    @FXML
    public void initialize() {
        final EventHandler<MouseEvent> onMouseClicked = event -> {
            if (event.getClickCount() == 2) {
                final TreeItem<AbstractEntity> selectedItem = treeview.getSelectionModel().getSelectedItem();
                if (selectedItem != null && selectedItem.isLeaf()) {
                    final AbstractEntity entity = selectedItem.getValue();
                    if (entity != null && entity instanceof AbstractDBEntity)
                        modeConsultationController.showConsultationForm((AbstractDBEntity) entity);
                }
            }
        };

        treeview.onMouseClickedProperty().bind(Bindings.createObjectBinding(() -> {
            if (getClickToShow() && getOnClickItem() == null)
                return onMouseClicked;
            else
                return getOnClickItem();
        }, clickToShowProperty(), onClickItemProperty()));

        column0.setCellValueFactory(param -> {
                    String label;
                    if (getOnGetLabel() != null)
                        label = param.getValue() == null ? null : getOnGetLabel().call((TreeViewNode) param.getValue());
                    else {
                        final AbstractEntity entity = param.getValue().getValue();
                        label = entity == null ? null : entity.buildLabel();
                    }
                    return new ReadOnlyStringWrapper(label);
                }
        );
        column0.setCellFactory(param -> {
                    final TreeTableCell<AbstractEntity, String> cell = new TreeTableCell<>();
                    cell.itemProperty().addListener((observable) -> {
                        final TreeItem<AbstractEntity> treeItem = cell.getTreeTableRow().getTreeItem();
                        //if (cell.getItem() != null)
                        if (treeItem != null && treeItem.getParent() != null && treeItem.getParent().equals(treeview.getRoot()))
                            cell.getStyleClass().add("node-bold");
                        else
                            cell.getStyleClass().remove("node-bold");
                    });
                    cell.textProperty().bind(Bindings.createStringBinding(() -> {
                        final TreeTableRow<AbstractEntity> tableRow = cell.getTreeTableRow();
                        if (tableRow == null) return null;

                        String label;
                        TreeItem<AbstractEntity> treeNode = tableRow.getTreeItem();
                        if (getOnGetLabel() != null)
                            label = treeNode == null ? null : getOnGetLabel().call((TreeViewNode) treeNode);
                        else {
                            final AbstractEntity entity = treeNode.getValue();
                            label = entity == null ? null : entity.buildLabel();
                        }
                        return label;
                    }, cell.itemProperty(), cell.tableRowProperty()));
                    return cell;
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

        column1.visibleProperty().bind(userPreferences.afficheNoteListesProperty());

        Platform.runLater(() -> treeview.setRoot(new TreeViewNode(null)));
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

    public TreeTableView<AbstractEntity> getTreeview() {
        return treeview;
    }

    public TreeTableColumn<AbstractEntity, String> getColumn0() {
        return column0;
    }

    public TreeTableColumn<AbstractEntity, AbstractEntity> getColumn1() {
        return column1;
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
                isLeaf = getOnIsLeaf() == null ? true : getOnIsLeaf().call(this);
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

    public class GetChildrenEvent extends ActionEvent {
        public GetChildrenEvent(@NamedArg("source") Object source, @NamedArg("target") EventTarget target) {
            super(source, target);
        }
    }
}
