package org.tetram.bdtheque.gui.controllers;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.AnchorPane;
import org.controlsfx.dialog.Dialogs;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.SpringFxmlLoader;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

@Controller
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

        repertoireController.selectedEntityProperty().addListener(new ChangeListener<AbstractDBEntity>() {
            @Override
            public void changed(ObservableValue<? extends AbstractDBEntity> observable, AbstractDBEntity oldValue, AbstractDBEntity newValue) {
                Dialogs.create().message(newValue.toString()).showInformation();
            }
        });
    }
}
