package org.fxsct;

import javafx.stage.Window;

import java.util.Iterator;
import java.util.ServiceConfigurationError;
import java.util.ServiceLoader;

public class SceneToolPlugin {
    public static void load(Window window) {
        try {
            Iterator<SceneToolProvider> loadIter = ServiceLoader.load(
                    SceneToolProvider.class).iterator();
            if (loadIter.hasNext()) {
                loadIter.next().load(window);
                System.out.println("Scene Tool plugin loaded.");
            } else {
                System.out.println("No Scene Tool plugin found.");
            }

        } catch (ServiceConfigurationError serviceError) {
            System.err.println("Scene Tool plugin configuration error.");
        }

    }

}
