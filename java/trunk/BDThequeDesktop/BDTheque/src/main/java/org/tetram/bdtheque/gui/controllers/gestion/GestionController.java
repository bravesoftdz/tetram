package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.beans.property.ObjectProperty;

import java.lang.ref.WeakReference;
import java.util.UUID;

/**
 * Created by Thierry on 02/07/2014.
 */
public interface GestionController {
    void setIdEntity(UUID id);

    ObjectProperty<WeakReference<FicheEditController>> editControllerProperty();

    FicheEditController getEditController();

    void setEditController(FicheEditController editController);
}
