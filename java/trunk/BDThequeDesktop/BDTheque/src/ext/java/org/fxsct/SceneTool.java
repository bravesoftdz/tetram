package org.fxsct;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.EventHandler;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.stage.Stage;
import javafx.stage.Window;

/**
 * @author ABSW
 */
public class SceneTool {

    private final ObservableList<Window> stages = FXCollections.observableArrayList();
    private Stage toolStage;
    private boolean debug;


    public SceneTool(Window primaryStage) {
        stages.add(primaryStage);
        stages.get(0).addEventFilter(KeyEvent.KEY_PRESSED, new EventHandler<KeyEvent>() {

            @Override
            public void handle(KeyEvent ev) {
                if (ev.getCode() == KeyCode.DOLLAR && ev.isControlDown() && ev.isShiftDown()) {
                    if (toolStage == null)
                        show();
                    else
                        hide();
                }
            }
        });
    }

    public void addStage(Stage s) {
        stages.add(s);
    }

    public void removeStage(Stage s) {
    }

    public void show() {

        if (toolStage == null) {
            toolStage = new Stage();
            toolStage.initOwner(stages.get(0));
            final FxSceneToolController controller = SceneToolFactory.createSceneToolController();
            Parent root = (Parent) controller.getView();
            controller.getStages().setAll(stages);
            toolStage.setScene(new Scene(root));
            toolStage.setTitle("FX Scene Tool");
            toolStage.setX(0);
            toolStage.setY(0);
            toolStage.getScene().getStylesheets().add(getClass().getResource("SceneTool.css").toExternalForm());
            if (debug) {
                SceneTool st = new SceneTool(toolStage);
            }
        }
        toolStage.show();
    }

    public void hide() {
        if (toolStage != null) {
            toolStage.hide();
            toolStage = null;
        }
    }

    public void debug() {
        this.debug = true;
//        st.show();
    }
}
