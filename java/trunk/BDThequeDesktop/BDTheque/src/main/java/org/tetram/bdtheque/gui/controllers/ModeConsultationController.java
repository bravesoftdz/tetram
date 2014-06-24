package org.tetram.bdtheque.gui.controllers;

import javafx.fxml.FXML;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.AnchorPane;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.SpringFxmlLoader;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

@Controller
public class ModeConsultationController extends WindowController {

    @FXML // ResourceBundle that was given to the FXMLLoader
    private ResourceBundle resources;

    @FXML // URL location of the FXML file that was given to the FXMLLoader
    private URL location;

    @FXML // fx:id="detailPane"
    private ScrollPane detailPane; // Value injected by FXMLLoader

    @FXML // fx:id="repertoirePane"
    private AnchorPane repertoirePane; // Value injected by FXMLLoader

    @FXML
        // This method is called by the FXMLLoader when initialization is complete
    void initialize() throws IOException {
        assert detailPane != null : "fx:id=\"detailPane\" was not injected: check your FXML file 'modeConsultation.fxml'.";
        assert repertoirePane != null : "fx:id=\"repertoirePane\" was not injected: check your FXML file 'modeConsultation.fxml'.";

        RepertoireController repertoireController = SpringFxmlLoader.load("repertoire.fxml");
        repertoirePane.getChildren().add(repertoireController.getView());
        AnchorPane.setBottomAnchor(repertoireController.getView(), 0.0);
        AnchorPane.setTopAnchor(repertoireController.getView(), 0.0);
        AnchorPane.setLeftAnchor(repertoireController.getView(), 0.0);
        AnchorPane.setRightAnchor(repertoireController.getView(), 0.0);
    }
}
