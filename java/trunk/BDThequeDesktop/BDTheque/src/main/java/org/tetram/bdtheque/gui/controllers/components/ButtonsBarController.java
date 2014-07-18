package org.tetram.bdtheque.gui.controllers.components;

import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

/**
 * Created by Thierry on 18/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/components/buttonsbar.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/components/buttonsbar.css")
})
public class ButtonsBarController extends WindowController {
    @FXML
    private Label lbMessage;
    @FXML
    private Button btCancel;
    @FXML
    private Button btOk;

    @FXML
    public void initialize() {

    }
}
