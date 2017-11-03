/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SceneToolFactory.java
 * Last modified by Tetram, on 2014-07-30T12:36:19CEST
 */

/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package org.fxsct;

import javafx.fxml.FXMLLoader;
import javafx.scene.Node;

import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author ABSW
 */
public class SceneToolFactory {

    private static <T extends Controller> T load(InputStream str) {
        FXMLLoader loader = new FXMLLoader();
        try {
            Node view = (Node) loader.load(str);
            T ret = (T) loader.getController();
            ret.setView(view);
            return ret;
        } catch (IOException ex) {
            Logger.getLogger(SceneToolFactory.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    private static <T extends Controller> T load(Class<?> cls, String relPath) {
        return load(cls.getResourceAsStream(relPath));

    }

    public static FxSceneToolController createSceneToolController() {
        return load(SceneToolFactory.class, "FxSceneTool.fxml");
    }

    public static NodeToolController createNodeToolController() {
        return load(SceneToolFactory.class, "NodeTool.fxml");
    }


}
