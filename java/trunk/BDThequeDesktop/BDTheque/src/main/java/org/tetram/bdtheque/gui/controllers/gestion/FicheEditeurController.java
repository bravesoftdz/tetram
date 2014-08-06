/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FicheEditeurController.java 
 * Last modified by Thierry, on 2014-08-06T10:53:56CEST
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

import java.util.UUID;

// TODO

/**
 * Created by Thierry on 06/08/2014.
 */
@Controller(value = "editEditeur")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheEditeur.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheEditeur-screenshot.jpg")
})
public class FicheEditeurController extends GestionControllerImpl {
    @Override
    public void setIdEntity(UUID id) {

    }

    @Override
    public void setDefaultLabel(String label) {

    }
}
