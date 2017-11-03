/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FlowItem.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.gui.utils;

import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Label;
import javafx.scene.control.Labeled;
import javafx.scene.layout.FlowPane;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAuteur;

import java.util.List;

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

    public static <E extends AbstractDBEntity> void fillViewFromList(List<E> list, FlowPane view) {
        fillViewFromList(list, view, null);
    }

    public static <E extends AbstractDBEntity> void fillViewFromList(List<E> list, FlowPane view, EventHandler<ActionEvent> onClickEvent) {
        list.forEach(entity -> {
            final boolean isAuteur = BaseAuteur.class.isAssignableFrom(entity.getClass());
            Labeled e;
            if (isAuteur)
                e = FlowItem.create(entity.buildLabel(), onClickEvent, ((BaseAuteur) entity).getPersonne());
            else
                e = FlowItem.create(entity.buildLabel(), onClickEvent, entity);
            view.getChildren().add(e);
        });
    }

}
