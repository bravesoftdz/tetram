package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.gui.controllers.WindowController;

import java.lang.ref.WeakReference;
import java.util.UUID;

/**
 * Created by Thierry on 21/07/2014.
 */
public abstract class GestionControllerImpl extends WindowController implements GestionController {

    private ObjectProperty<WeakReference<FicheEditController>> editController = new SimpleObjectProperty<>(this, "editController", null);

    @Override
    public abstract void setIdEntity(UUID id);

    @Override
    public ObjectProperty<WeakReference<FicheEditController>> editControllerProperty() {
        return editController;
    }

    @Override
    public FicheEditController getEditController() {
        return this.editController.get() == null ? null : this.editController.get().get();
    }

    @Override
    public void setEditController(FicheEditController editController) {
        this.editController.set(editController == null ? null : new WeakReference<>(editController));
    }
}
