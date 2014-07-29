/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityWebHyperlink.java
 * Last modified by Tetram, on 2014-07-29T11:02:07CEST
 */

package org.tetram.bdtheque.gui.utils;

import javafx.beans.binding.Bindings;
import javafx.beans.binding.BooleanBinding;
import javafx.beans.property.ObjectProperty;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Labeled;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.utils.StringUtils;

import java.awt.*;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;

/**
 * Created by Thierry on 08/07/2014.
 */
public class EntityWebHyperlink extends Hyperlink {

    public EntityWebHyperlink(@NotNull ObjectProperty<URL> url, boolean alwaysVisible) {
        super();
        setText(null);
        final Image image = new Image(getClass().getResourceAsStream("/org/tetram/bdtheque/graphics/png/16x16/network.png"));
        setContentDisplay(ContentDisplay.GRAPHIC_ONLY);
        setGraphic(new ImageView(image));
        setOnAction(event -> {
            try {
                final URL value = url.get();
                if (value != null)
                    Desktop.getDesktop().browse(value.toURI());
            } catch (IOException | URISyntaxException e) {
                e.printStackTrace();
            }
        });

        BooleanBinding urlValid = Bindings.createBooleanBinding(() -> url.get() != null && !StringUtils.isNullOrEmpty(url.get().getHost()), url);
        if (alwaysVisible)
            disableProperty().bind(urlValid.not());
        else
            visibleProperty().bind(urlValid);
    }


    public static void addToLabeled(Labeled node, ObjectProperty<URL> url, ContentDisplay contentDisplay, boolean alwaysVisible) {
        if (url == null)
            node.setGraphic(null);
        else
            node.setGraphic(new EntityWebHyperlink(url, alwaysVisible));
        node.setContentDisplay(contentDisplay);
    }

    public static void addToLabeled(Labeled node, ObjectProperty<URL> url, ContentDisplay contentDisplay) {
        addToLabeled(node, url, contentDisplay, false);
    }

    public static void addToLabeled(Labeled node, ObjectProperty<URL> url) {
        addToLabeled(node, url, ContentDisplay.RIGHT, false);
    }

    public static void addToLabeled(Labeled node, ObjectProperty<URL> url, boolean alwaysVisible) {
        addToLabeled(node, url, ContentDisplay.RIGHT, alwaysVisible);
    }

}
