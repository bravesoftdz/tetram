package org.tetram.bdtheque.gui.controllers;

import javafx.scene.Node;
import javafx.stage.Stage;

/**
 * Created by Thierry on 21/06/2014.
 */
public class WindowController {
    Stage dialog;
    private Node view;

    public Stage getDialog() {
        return dialog;
    }

    public void setDialog(Stage dialog) {
        this.dialog = dialog;
    }

    public Node getView() {
        return view;
    }

    public void setView(Node view) {
        this.view = view;
    }

    /**
     * A utiliser à la place de l'injection "Initialize" si on a besoin de getView et/ou getDialog
     */
    public void controllerLoaded() {
    }
}
