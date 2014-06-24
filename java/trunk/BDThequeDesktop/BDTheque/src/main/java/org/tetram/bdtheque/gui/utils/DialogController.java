package org.tetram.bdtheque.gui.utils;

import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.Window;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.SpringFxmlLoader;
import org.tetram.bdtheque.gui.controllers.WindowController;

import java.io.IOException;

/**
 * Created by Thierry on 24/06/2014.
 */
public class DialogController extends Stage {

    private WindowController windowController;

    public DialogController(Window owner, @NonNls String url) throws IOException {
        this(owner, url, true);
    }

    public DialogController(Window owner, @NonNls String url, boolean resizable) throws IOException {
        initModality(Modality.APPLICATION_MODAL);
        initOwner(owner);
        windowController = SpringFxmlLoader.load(url, this);
        Scene scene = new Scene((Parent) windowController.getView());
        setScene(scene);
        setResizable(resizable);
        sizeToScene();
    }

    @SuppressWarnings("unchecked")
    public static <T extends WindowController> T showPreferences(Stage owner) throws IOException {
        final DialogController dialogController = new DialogController(owner, "preferences.fxml", false);
        dialogController.showAndWait();
        return (T) dialogController.getWindowController();
    }

    public WindowController getWindowController() {
        return windowController;
    }
}
