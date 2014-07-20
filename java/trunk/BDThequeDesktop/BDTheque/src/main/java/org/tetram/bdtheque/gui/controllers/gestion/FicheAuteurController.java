package org.tetram.bdtheque.gui.controllers.gestion;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

import java.util.UUID;

/**
 * Created by Thierry on 18/07/2014.
 */
@Controller(value = "editAuteur")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheAuteur.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheAuteur-screenshot.jpg")
})
public class FicheAuteurController extends WindowController implements GestionController {
    @Override
    public void setIdEntity(UUID id) {

    }
}
