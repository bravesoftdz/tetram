package org.tetram.bdtheque.gui.controllers;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.fxml.FXML;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.AnchorPane;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.gui.utils.History;
import org.tetram.bdtheque.spring.SpringFxmlLoader;
import org.tetram.bdtheque.utils.FileLink;

import java.io.IOException;

@Controller
// c'est la valeur par défaut, mais contrairement aux autres, il faut impérativement que ce controller soit un singleton
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)
@FileLink("/org/tetram/bdtheque/gui/modeConsultation.fxml")
public class ModeConsultationController extends WindowController implements ModeController {

    @Autowired
    private History history;

    @FXML
    private ScrollPane detailPane;
    @FXML
    private AnchorPane repertoirePane;

    private ObjectProperty<AbstractDBEntity> currentEntity = new SimpleObjectProperty<>(this, "currentEntity", null);


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

        history.refresh();
    }

    public ScrollPane getDetailPane() {
        return detailPane;
    }
}
