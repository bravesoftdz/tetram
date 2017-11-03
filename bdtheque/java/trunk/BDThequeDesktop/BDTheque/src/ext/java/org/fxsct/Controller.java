/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package org.fxsct;

import javafx.scene.Node;

/**
 * @author ABSW
 */
public abstract class Controller {
    private Node view;

    public Node getView() {
        return view;
    }

    void setView(Node view) {
        this.view = view;
    }
}
