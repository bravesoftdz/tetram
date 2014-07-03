package org.tetram.bdtheque.gui.utils;

import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Label;
import javafx.scene.control.Labeled;

/**
 * Created by Thierry on 03/07/2014.
 */
public class FlowItem {

    public static Labeled create(String text) {
        return create(text, null, null);
    }

    public static Labeled create(String text, EventHandler<ActionEvent> onClick, Object userData) {
        Labeled l;
        if (onClick == null) {
            l = new Label();
        } else {
            l = new Hyperlink();
            ((Hyperlink) l).setOnAction(onClick);
        }
        l.setText(text);
        l.setContentDisplay(ContentDisplay.RIGHT);
        l.setGraphicTextGap(1);
        l.setUserData(userData);

        final Label label = new Label();
        label.setText("; ");
        l.setGraphic(label);

        return l;
    }

}
