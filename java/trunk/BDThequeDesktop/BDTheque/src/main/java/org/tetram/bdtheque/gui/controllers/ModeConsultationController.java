package org.tetram.bdtheque.gui.controllers;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;
import org.controlsfx.dialog.Dialogs;
import org.jetbrains.annotations.NonNls;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.SpringFxmlLoader;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.dao.mappers.FileLink;
import org.tetram.bdtheque.gui.controllers.consultation.ConsultationController;

import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

@Controller
@FileLink("/org/tetram/bdtheque/gui/modeConsultation.fxml")
public class ModeConsultationController extends WindowController {

    @FXML
    private ResourceBundle resources;
    @FXML
    private URL location;

    @FXML
    private ScrollPane detailPane;
    @FXML
    private AnchorPane repertoirePane;

    public AnchorPane getRepertoirePane() {
        return repertoirePane;
    }

    @FXML
    void initialize() throws IOException {
        RepertoireController repertoireController = SpringFxmlLoader.load("repertoire.fxml");
        repertoirePane.getChildren().add(repertoireController.getView());
        AnchorPane.setBottomAnchor(repertoireController.getView(), 0.0);
        AnchorPane.setTopAnchor(repertoireController.getView(), 0.0);
        AnchorPane.setLeftAnchor(repertoireController.getView(), 0.0);
        AnchorPane.setRightAnchor(repertoireController.getView(), 0.0);

        @NonNls Map<Class<? extends AbstractDBEntity>, String> entitiesUrl = new HashMap<>();
        entitiesUrl.put(AlbumLite.class, "ficheAlbum.fxml");

        repertoireController.selectedEntityProperty().addListener(new ChangeListener<AbstractDBEntity>() {
            @Override
            public void changed(ObservableValue<? extends AbstractDBEntity> observable, AbstractDBEntity oldValue, AbstractDBEntity newValue) {
                if (newValue == null) return;

                String url = entitiesUrl.get(newValue.getClass());
                if (url != null) {
                    ConsultationController controller = SpringFxmlLoader.load("consultation/" + url);
                    controller.setIdEntity(newValue.getId());
                    final Pane view = (Pane) ((WindowController) controller).getView();
                    detailPane.setContent(view);
                    view.minWidthProperty().bind(detailPane.widthProperty());
                    view.minHeightProperty().bind(detailPane.heightProperty());
                } else
                    Dialogs.create().message(newValue.toString()).showInformation();

            }
        });
    }
}
