package org.tetram.bdtheque.gui.controllers;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.scene.Node;
import javafx.stage.Stage;

/**
 * Created by Thierry on 21/06/2014.
 */

public class WindowController {
    private ObjectProperty<Stage> dialog = new SimpleObjectProperty<>(this, "dialog", null);
    private ObjectProperty<Node> view = new SimpleObjectProperty<>(this, "view", null);

    public Stage getDialog() {
        return dialog.get();
    }

    public void setDialog(Stage dialog) {
        this.dialog.set(dialog);
    }

    public ObjectProperty<Stage> dialogProperty() {
        return dialog;
    }

    public Node getView() {
        return view.get();
    }

    public void setView(Node view) {
        this.view.set(view);
    }

    public ObjectProperty<Node> viewProperty() {
        return view;
    }

    /**
     * A utiliser à la place de l'injection "Initialize" si on a besoin de getView et/ou getDialog
     */
    public void controllerLoaded() {
    }
}
