package org.tetram.bdtheque.gui.utils;

import javafx.beans.property.ListProperty;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Label;
import javafx.scene.control.Labeled;
import javafx.scene.layout.FlowPane;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;

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

    public static <E extends AbstractDBEntity> void fillViewFromList(ListProperty<E> list, FlowPane view) {
        fillViewFromList(list, view, null);
    }

    public static <E extends AbstractDBEntity> void fillViewFromList(ListProperty<E> list, FlowPane view, EventHandler<ActionEvent> onClickEvent) {
        //if (!list.isEmpty()) view.getStyleClass().add(CSS_FLOW_B0RDER);
        list.forEach(entity -> {
            final Labeled e = FlowItem.create(entity.buildLabel(), onClickEvent, entity);
            // finalement pas très utile
            /*
            if (entity instanceof WebLinkedEntity)
                EntityWebHyperlink.addToLabeled(e, ((WebLinkedEntity) entity).getSiteWeb());
            */
            view.getChildren().add(e);
        });
    }

}
