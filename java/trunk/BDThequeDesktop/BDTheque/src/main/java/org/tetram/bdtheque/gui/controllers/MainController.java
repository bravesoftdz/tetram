package org.tetram.bdtheque.gui.controllers;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.MenuBar;
import javafx.scene.control.ToolBar;
import javafx.scene.layout.AnchorPane;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.SpringFxmlLoader;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.dao.SerieDao;
import org.tetram.bdtheque.utils.StringUtils;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;
import java.util.UUID;

@Controller
public class MainController extends WindowController {

    @NonNls
    public static final UUID ID_SERIE_SILLAGE = StringUtils.GUIDStringToUUID("{69302EDB-6ED6-4DA3-A2E1-65B7B12BCB51}");

    @Autowired
    private SerieDao serieDao;

    @FXML // ResourceBundle that was given to the FXMLLoader
    private ResourceBundle resources;

    @FXML // URL location of the FXML file that was given to the FXMLLoader
    private URL location;

    @FXML // fx:id="menuBar"
    private MenuBar menuBar; // Value injected by FXMLLoader

    @FXML // fx:id="toolBar"
    private ToolBar toolBar; // Value injected by FXMLLoader

    @FXML // fx:id="buttonTest"
    private Button buttonTest;

    @FXML// fx:id="detailPane"
    private AnchorPane detailPane;

    @FXML
        // This method is called by the FXMLLoader when initialization is complete
    void initialize() throws IOException {
        assert menuBar != null : "fx:id=\"menuBar\" was not injected: check your FXML file 'main.fxml'.";
        assert toolBar != null : "fx:id=\"toolBar\" was not injected: check your FXML file 'main.fxml'.";
        assert buttonTest != null : "fx:id=\"buttonTest\" was not injected: check your FXML file 'main.fxml'.";
        assert detailPane != null : "fx:id=\"detailPane\" was not injected: check your FXML file 'main.fxml'.";

        ModeConsultationController modeConsultationController = SpringFxmlLoader.load("modeConsultation.fxml");
        detailPane.getChildren().add(modeConsultationController.getView());
        AnchorPane.setBottomAnchor(modeConsultationController.getView(), 0.0);
        AnchorPane.setTopAnchor(modeConsultationController.getView(), 0.0);
        AnchorPane.setLeftAnchor(modeConsultationController.getView(), 0.0);
        AnchorPane.setRightAnchor(modeConsultationController.getView(), 0.0);
    }

    public void menuQuitClick(ActionEvent actionEvent) {
        dialog.close();
    }

    public void buttonTestClick(ActionEvent actionEvent) {
        Serie serie = serieDao.get(ID_SERIE_SILLAGE);
        buttonTest.setText(serie.getTitreSerie());
    }
}
