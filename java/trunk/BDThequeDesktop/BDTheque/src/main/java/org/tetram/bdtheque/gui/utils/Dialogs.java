package org.tetram.bdtheque.gui.utils;

import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.beans.property.ReadOnlyObjectWrapper;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.Window;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.SpringFxmlLoader;
import org.tetram.bdtheque.gui.controllers.DialogController;
import org.tetram.bdtheque.gui.controllers.WindowController;

/**
 * Created by Thierry on 24/06/2014.
 */
public class Dialogs extends Stage {

    private ReadOnlyObjectWrapper<DialogController> dialogController = new ReadOnlyObjectWrapper<>(this, "dialogController", null);

    private Dialogs(Window owner, @NonNls String url, boolean resizable) {
        initModality(Modality.APPLICATION_MODAL);
        initOwner(owner);
        dialogController.set(SpringFxmlLoader.load(url, this));
        Scene scene = new Scene((Parent) getDialogController().getView());
        setScene(scene);
        setResizable(resizable);
        sizeToScene();
    }

    @SuppressWarnings("unchecked")
    public static <T extends WindowController> T showPreferences(Stage owner) {
        final Dialogs dialogs = new Dialogs(owner, "preferences.fxml", false);
        dialogs.showAndWait();
        return (T) dialogs.getDialogController();
    }

    public DialogController getDialogController() {
        return dialogController.get();
    }

    @SuppressWarnings("UnusedDeclaration")
    public ReadOnlyObjectProperty<DialogController> dialogControllerProperty() {
        return dialogController.getReadOnlyProperty();
    }
}
