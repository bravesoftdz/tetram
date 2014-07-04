package org.tetram.bdtheque.gui.controllers;

import javafx.fxml.FXML;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.AnchorPane;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.SpringFxmlLoader;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.gui.utils.Forms;

import java.io.IOException;
import java.net.URL;
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

        repertoireController.selectedEntityProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue == null) return;
            showConsultationForm(newValue);
        });
    }

    public void showConsultationForm(AbstractDBEntity entity) {
        Forms.showFiche(entity, detailPane);
    }
}
