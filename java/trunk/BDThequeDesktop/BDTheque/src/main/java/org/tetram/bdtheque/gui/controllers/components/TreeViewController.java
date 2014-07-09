package org.tetram.bdtheque.gui.controllers.components;

import javafx.beans.binding.Bindings;
import javafx.beans.property.*;
import javafx.beans.value.ObservableValue;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.TreeItem;
import javafx.scene.control.TreeTableCell;
import javafx.scene.control.TreeTableColumn;
import javafx.scene.control.TreeTableView;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.util.Callback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.AbstractEntity;
import org.tetram.bdtheque.data.bean.EvaluatedEntity;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.controllers.ModeConsultationController;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.utils.NotationResource;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

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

    @FXML
    public void initialize() {
        final Callback<TreeTableColumn.CellDataFeatures<AbstractEntity, String>, ObservableValue<String>> labelValueFactory = param -> {
            final AbstractEntity entity = param.getValue().getValue();
            /*
            if (entity instanceof AlbumLite && repertoireGroup.getValue() == TypeRepertoireAlbumEntry.PAR_SERIE)
                return new ReadOnlyStringWrapper(((AlbumLite) entity).buildLabel(false));
            else
            */
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
        column0.setCellValueFactory(labelValueFactory);
        column1.setCellValueFactory(imageValueCellFactory);
        column1.setCellFactory(imageCellFactory);
        column1.visibleProperty().bind(userPreferences.afficheNoteListesProperty());
    }

    public boolean getClickToShow() {
        return clickToShow.get();
    }

    public BooleanProperty clickToShowProperty() {
        return clickToShow;
    }

    public void setClickToShow(boolean clickToShow) {
        this.clickToShow.set(clickToShow);
    }

    public EventHandler<MouseEvent> getOnClickItem() {
        return onClickItem.get();
    }

    public ObjectProperty<EventHandler<MouseEvent>> onClickItemProperty() {
        return onClickItem;
    }

    public void setOnClickItem(EventHandler<MouseEvent> onClickItem) {
        this.onClickItem.set(onClickItem);
    }
}
