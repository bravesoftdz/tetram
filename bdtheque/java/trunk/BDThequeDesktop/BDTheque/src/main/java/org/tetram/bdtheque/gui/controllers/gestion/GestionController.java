/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GestionController.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.beans.property.ObjectProperty;

import java.lang.ref.WeakReference;
import java.util.UUID;

/**
 * Created by Thierry on 02/07/2014.
 */
public interface GestionController {
    void setIdEntity(UUID id);

    void setDefaultLabel(String label);

    ObjectProperty<WeakReference<FicheEditController<?>>> editControllerProperty();

    FicheEditController<?> getEditController();

    void setEditController(FicheEditController<?> editController);
}
