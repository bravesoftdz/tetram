/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GestionControllerImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.gui.controllers.WindowController;

import java.lang.ref.WeakReference;

/**
 * Created by Thierry on 21/07/2014.
 */
public abstract class GestionControllerImpl extends WindowController implements GestionController {

    private final ObjectProperty<WeakReference<FicheEditController<?>>> editController = new SimpleObjectProperty<>(this, "editController", null);

    @Override
    public ObjectProperty<WeakReference<FicheEditController<?>>> editControllerProperty() {
        return editController;
    }

    @Override
    public FicheEditController<?> getEditController() {
        return this.editController.get() == null ? null : this.editController.get().get();
    }

    @Override
    public void setEditController(FicheEditController<?> editController) {
        this.editController.set(editController == null ? null : new WeakReference<>(editController));
    }
}
