package org.tetram.bdtheque.gui.utils;

import javafx.beans.property.ObjectProperty;
import javafx.scene.Node;
import javafx.scene.layout.Pane;
import javafx.scene.layout.VBox;
import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.SpringFxmlLoader;
import org.tetram.bdtheque.gui.controllers.FicheAlbumController;
import org.tetram.bdtheque.gui.controllers.WindowController;

import java.util.UUID;

/**
 * Created by Thierry on 30/06/2014.
 */
public class Forms {

    @SuppressWarnings("unchecked")
    @Contract("null,null,_->fail ; !null,!null,_->fail")
    private static <T extends WindowController> T showWindow(Pane containerPane, ObjectProperty<Node> containerNode, @NonNls String url) {
        if (!(containerNode == null ^ containerPane == null))
            throw new RuntimeException("You can define only one container.");

        final WindowController controller = SpringFxmlLoader.load(url);
        if (containerNode != null)
            containerNode.set(controller.getView());
        else
            containerPane.getChildren().add(controller.getView());

        return (T) controller;
    }

    public static FicheAlbumController showFicheAlbum(UUID idAlbum, Pane containerPane, ObjectProperty<Node> containerNode) {
        final FicheAlbumController controller = showWindow(containerPane, containerNode, "consultation/ficheAlbum.fxml");
        controller.showAlbum(idAlbum);
        return controller;
    }

}
