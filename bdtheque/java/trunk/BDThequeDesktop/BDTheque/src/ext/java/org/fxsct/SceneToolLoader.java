package org.fxsct;

import javafx.stage.Window;

public class SceneToolLoader implements SceneToolProvider {

    @Override
    public void load(Window window) {
        @SuppressWarnings("unused")
        SceneTool st = new SceneTool(window);
    }

}
