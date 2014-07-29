/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SpringFxmlLoader.java
 * Last modified by Tetram, on 2014-07-29T11:02:07CEST
 */

package org.tetram.bdtheque.spring;

import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.stage.Stage;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.utils.I18nSupport;

import java.io.IOException;

/**
 * Created by Thierry on 21/06/2014.
 */
public class SpringFxmlLoader {
    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_GUI = "/org/tetram/bdtheque/gui/";

    public static <T extends WindowController> T load(@NonNls String url) throws RuntimeException {
        return load(url, null);
    }

    @SuppressWarnings("unchecked")
    public static <T extends WindowController> T load(@NonNls String url, Stage stage) throws RuntimeException {
        try {
            FXMLLoader loader = new FXMLLoader(SpringFxmlLoader.class.getResource(ORG_TETRAM_BDTHEQUE_GUI + url));
            // apparament Intellij 13.1.3 n'est pas complètement Java8 compliant
            //noinspection Convert2MethodRef
            loader.setControllerFactory(aClass -> SpringContext.CONTEXT.getBean(aClass));
            loader.setResources(I18nSupport.getCurrentBundle());
            Parent view = loader.load();

            view.getStylesheets().addAll(SpringFxmlLoader.class.getResource(ORG_TETRAM_BDTHEQUE_GUI + "theme.css").toExternalForm());
            WindowController controller = loader.getController();
            controller.setView(view);
            controller.setDialog(stage);
            controller.controllerLoaded();

            return (T) controller;
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
