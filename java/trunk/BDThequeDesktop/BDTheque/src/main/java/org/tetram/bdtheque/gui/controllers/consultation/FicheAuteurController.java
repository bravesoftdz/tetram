package org.tetram.bdtheque.gui.controllers.consultation;

import javafx.fxml.FXML;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.controllers.components.TreeViewController;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

import java.util.UUID;

/**
 * Created by Thierry on 09/07/2014.
 */
@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheAuteur.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheAuteur-screenshot.jpg")
})
public class FicheAuteurController extends WindowController implements ConsultationController {

    @FXML
    private TreeViewController seriesController;

    @Override
    public void setIdEntity(UUID id) {

    }
}
