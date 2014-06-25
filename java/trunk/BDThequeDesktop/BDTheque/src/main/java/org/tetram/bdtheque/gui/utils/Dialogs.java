package org.tetram.bdtheque.gui.utils;

import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.Window;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.SpringFxmlLoader;
import org.tetram.bdtheque.gui.controllers.DialogController;
import org.tetram.bdtheque.gui.controllers.WindowController;

import java.io.IOException;

/**
 * Created by Thierry on 24/06/2014.
 */
public class Dialogs extends Stage {

    private DialogController dialogController;

    public Dialogs(Window owner, @NonNls String url) throws IOException {
        this(owner, url, true);
    }

    public Dialogs(Window owner, @NonNls String url, boolean resizable) throws IOException {
        initModality(Modality.APPLICATION_MODAL);
        initOwner(owner);
        dialogController = SpringFxmlLoader.load(url, this);
        Scene scene = new Scene((Parent) dialogController.getView());
        setScene(scene);
        setResizable(resizable);
        sizeToScene();
    }

    @SuppressWarnings("unchecked")
    public static <T extends WindowController> T showPreferences(Stage owner) throws IOException {
        final Dialogs dialogs = new Dialogs(owner, "preferences.fxml", false);
        dialogs.showAndWait();
        return (T) dialogs.getDialogController();
    }

    public WindowController getDialogController() {
        return dialogController;
    }
}
