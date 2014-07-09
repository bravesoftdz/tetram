package org.tetram.bdtheque.gui.utils;

import javafx.beans.property.ObjectProperty;
import javafx.scene.Node;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.Pane;
import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.*;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.controllers.consultation.ConsultationController;
import org.tetram.bdtheque.spring.SpringFxmlLoader;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Thierry on 30/06/2014.
 */
public class Forms {

    @NonNls
    private static Map<Class<? extends AbstractDBEntity>, String> entitiesUrl;

    static {
        entitiesUrl = new HashMap<>();
        entitiesUrl.put(AlbumLite.class, "consultation/ficheAlbum.fxml");
        entitiesUrl.put(Album.class, "consultation/ficheAlbum.fxml");
        entitiesUrl.put(SerieLite.class, "consultation/ficheSerie.fxml");
        entitiesUrl.put(Serie.class, "consultation/ficheSerie.fxml");
    }

    // on ne peut pas simplement utiliser entitiesUrl.get : CGLIB ajoute une surcharge
    static String searchForURL(Class<? extends AbstractDBEntity> clasz) {
        for (Map.Entry<Class<? extends AbstractDBEntity>, String> entry : entitiesUrl.entrySet()) {
            if (entry.getKey().isAssignableFrom(clasz))
                return entry.getValue();
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    @Contract("null,_->fail")
    private static <T extends WindowController> T showWindow(Object container, @NonNls String url) {
        if (container == null)
            throw new RuntimeException("You must define one container.");

        final WindowController controller = SpringFxmlLoader.load(url);

        final Pane view = (Pane) controller.getView();
        if (container instanceof Pane) {
            Pane containerPane = (Pane) container;
            containerPane.getChildren().add(view);
            view.prefWidthProperty().bind(containerPane.widthProperty());
            view.prefHeightProperty().bind(containerPane.heightProperty());
        } else if (container instanceof ScrollPane) {
            ScrollPane containerPane = (ScrollPane) container;
            containerPane.setContent(view);
            view.prefWidthProperty().bind(containerPane.widthProperty());
            view.prefHeightProperty().bind(containerPane.heightProperty());
        } else if (container instanceof ObjectProperty) {
            ObjectProperty<Node> containerNode = (ObjectProperty<Node>) container;
            containerNode.set(view);
        }

        return (T) controller;
    }

    @SuppressWarnings("UnusedDeclaration")
    public static <T extends WindowController & ConsultationController> T showFiche(AbstractDBEntity entity, Pane container) {
        String url = searchForURL(entity.getClass());
        if (url == null) {
            org.controlsfx.dialog.Dialogs.create().message(entity.toString()).showInformation();
            return null;
        }

        T controller = showWindow(container, url);
        controller.setIdEntity(entity.getId());
        return controller;
    }

    @SuppressWarnings("UnusedDeclaration")
    public static <T extends WindowController & ConsultationController> T showFiche(AbstractDBEntity entity, ScrollPane container) {
        String url = searchForURL(entity.getClass());
        if (url == null) {
            org.controlsfx.dialog.Dialogs.create().message(entity.toString()).showInformation();
            return null;
        }

        T controller = showWindow(container, url);
        controller.setIdEntity(entity.getId());
        return controller;
    }

    @SuppressWarnings("UnusedDeclaration")
    public static <T extends WindowController & ConsultationController> T showFiche(AbstractDBEntity entity, ObjectProperty<Node> container) {
        String url = searchForURL(entity.getClass());
        if (url == null) {
            org.controlsfx.dialog.Dialogs.create().message(entity.toString()).showInformation();
            return null;
        }

        T controller = showWindow(container, url);
        controller.setIdEntity(entity.getId());
        return controller;
    }

}
