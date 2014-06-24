package org.tetram.bdtheque.gui.controllers;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import org.springframework.stereotype.Controller;

/**
 * Created by Thierry on 24/06/2014.
 */
@Controller
public class PreferencesController extends WindowController {

    private String result;

    @FXML
        // This method is called by the FXMLLoader when initialization is complete
    void initialize() {

    }

    public void btnCancelClick(ActionEvent actionEvent) {
        result = ((Button) actionEvent.getSource()).getText();
        getDialog().close();
    }

    public void btnOkClick(ActionEvent actionEvent) {
        // TODO save new options
        result = ((Button) actionEvent.getSource()).getText();
        getDialog().close();
    }

    public String getResult() {
        return result;
    }
}
