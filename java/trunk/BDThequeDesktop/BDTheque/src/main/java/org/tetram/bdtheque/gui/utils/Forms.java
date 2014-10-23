/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * Forms.java
 * Last modified by Tetram, on 2014-10-23T14:37:39CEST
 */

package org.tetram.bdtheque.gui.utils;

import javafx.beans.property.*;
import javafx.scene.Node;
import javafx.scene.control.Alert;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.abstractentities.*;
import org.tetram.bdtheque.gui.controllers.*;
import org.tetram.bdtheque.gui.controllers.consultation.ConsultationController;
import org.tetram.bdtheque.gui.controllers.gestion.FicheEditController;
import org.tetram.bdtheque.gui.controllers.gestion.GestionController;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.spring.SpringFxmlLoader;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Created by Thierry on 30/06/2014.
 */
public class Forms {

    @NonNls
    private static final Map<Class<? extends AbstractDBEntity>, String> entitiesUrlFiche;
    @NonNls
    private static final Map<Class<? extends AbstractDBEntity>, String> entitiesUrlEdit;

    private static final ReadOnlyStringWrapper lastUrl = new ReadOnlyStringWrapper(null, "lastURL", null);
    private static final ReadOnlyObjectWrapper<Object> lastContainer = new ReadOnlyObjectWrapper<>(null, "lastContainer", null);
    private static final ReadOnlyObjectWrapper<Node> lastView = new ReadOnlyObjectWrapper<>(null, "lastView", null);
    private static final ReadOnlyObjectWrapper<WindowController> lastController = new ReadOnlyObjectWrapper<>(null, "lastController", null);

    static {
        entitiesUrlFiche = new HashMap<>();
        entitiesUrlFiche.put(BaseAlbum.class, "consultation/ficheAlbum.fxml");
        entitiesUrlFiche.put(BaseSerie.class, "consultation/ficheSerie.fxml");
        entitiesUrlFiche.put(BasePersonne.class, "consultation/ficheAuteur.fxml");
        entitiesUrlFiche.put(BaseAuteur.class, "consultation/ficheAuteur.fxml");
        entitiesUrlFiche.put(BaseUnivers.class, "consultation/ficheUnivers.fxml");
        entitiesUrlFiche.put(BaseParaBD.class, "consultation/ficheParabd.fxml");

        entitiesUrlEdit = new HashMap<>();
        //entitiesUrlEdit.put(BaseAlbum.class, "gestion/ficheAlbum.fxml");
        //entitiesUrlEdit.put(BaseSerie.class, "gestion/ficheSerie.fxml");
        entitiesUrlEdit.put(BasePersonne.class, "gestion/ficheAuteur.fxml");
        entitiesUrlEdit.put(BaseAuteur.class, "gestion/ficheAuteur.fxml");
        entitiesUrlEdit.put(BaseUnivers.class, "gestion/ficheUnivers.fxml");
        entitiesUrlEdit.put(BaseEditeur.class, "gestion/ficheEditeur.fxml");
        entitiesUrlEdit.put(BaseCollection.class, "gestion/ficheCollection.fxml");
        //entitiesUrlEdit.put(BaseParaBD.class, "gestion/ficheParabd.fxml");
        entitiesUrlEdit.put(BaseGenre.class, "gestion/ficheGenre.fxml");
    }

    public static String getLastUrl() {
        return lastUrl.get();
    }

    public static ReadOnlyStringProperty lastUrlProperty() {
        return lastUrl.getReadOnlyProperty();
    }

    public static Object getLastContainer() {
        return lastContainer.get();
    }

    public static ReadOnlyObjectProperty<Object> lastContainerProperty() {
        return lastContainer.getReadOnlyProperty();
    }

    public static Node getLastView() {
        return lastView.get();
    }

    public static ReadOnlyObjectProperty<Node> lastViewProperty() {
        return lastView.getReadOnlyProperty();
    }

    public static WindowController getLastController() {
        return lastController.get();
    }

    public static ReadOnlyObjectProperty<WindowController> lastControllerProperty() {
        return lastController.getReadOnlyProperty();
    }

    static String searchForURL(Class<? extends AbstractDBEntity> clasz) {
        for (Map.Entry<Class<? extends AbstractDBEntity>, String> entry : entitiesUrlFiche.entrySet()) {
            if (entry.getKey().isAssignableFrom(clasz))
                return entry.getValue();
        }
        return null;
    }

    @Contract("null,_->fail ; _,null->fail")
    public static void setViewToContainer(Node view, Object container) {
        Objects.requireNonNull(view);
        Objects.requireNonNull(container);

        final Pane pane = view instanceof Pane ? (Pane) view : null;
        if (container instanceof StackPane) {
            StackPane containerPane = (StackPane) container;
            containerPane.getChildren().clear();
            containerPane.getChildren().add(view);
        } else if (container instanceof AnchorPane) {
            AnchorPane containerPane = (AnchorPane) container;
            containerPane.getChildren().clear();
            containerPane.getChildren().add(view);
            AnchorPane.setTopAnchor(view, 0.0);
            AnchorPane.setLeftAnchor(view, 0.0);
            AnchorPane.setBottomAnchor(view, 0.0);
            AnchorPane.setRightAnchor(view, 0.0);
        } else if (container instanceof Pane) {
            Pane containerPane = (Pane) container;
            containerPane.getChildren().clear();
            containerPane.getChildren().add(view);
            if (pane != null) {
                pane.prefWidthProperty().bind(containerPane.widthProperty());
                pane.prefHeightProperty().bind(containerPane.heightProperty());
            }
        } else if (container instanceof ScrollPane) {
            ScrollPane containerPane = (ScrollPane) container;
            containerPane.setContent(view);
            if (pane != null) {
                pane.prefWidthProperty().bind(containerPane.widthProperty().subtract(16));
                pane.prefHeightProperty().bind(containerPane.heightProperty().subtract(16));
            }
        } else if (container instanceof ObjectProperty) {
            @SuppressWarnings("unchecked") ObjectProperty<Node> containerNode = (ObjectProperty<Node>) container;
            containerNode.set(view);
        }

        lastView.set(view);
        lastContainer.set(container);
    }

    @SuppressWarnings("unchecked")
    @Contract("null,_->fail")
    private static <T extends WindowController> T showWindow(Object container, @NonNls String url) {
        if (container == null)
            throw new RuntimeException("You must define one container.");

        final WindowController controller = SpringFxmlLoader.load(url);

        setViewToContainer(controller.getView(), container);
        lastController.set(controller);
        lastUrl.set(url);
        return (T) controller;
    }

    public static <T extends WindowController & ConsultationController> T showFiche(AbstractDBEntity entity) {
        String url = entitiesUrlFiche.get(entity.getBaseClass());
        if (url == null) {
            new Alert(Alert.AlertType.INFORMATION, entity.toString()).show();
            return null;
        }

        ModeConsultationController consultationController = SpringContext.CONTEXT.getBean(ModeConsultationController.class);
        T controller = showWindow(consultationController.getDetailPane(), url);
        controller.setIdEntity(entity.getId());
        return controller;
    }

    public static <T extends WindowController & GestionController> FicheEditController<T> showEdit(AbstractDBEntity entity) {
        String url = entitiesUrlEdit.get(entity.getBaseClass());
        if (url == null) {
            new Alert(Alert.AlertType.INFORMATION, entity.toString()).show();
            return null;
        }

        MainController mainController = SpringContext.CONTEXT.getBean(MainController.class);
        FicheEditController<T> controller = showWindow(mainController.getDetailPane(), "gestion/ficheGeneric.fxml");
        final T childController = showWindow(controller.getDetailPane(), url);
        childController.setEditController(controller);
        controller.setChildController(childController);
        controller.getChildController().setIdEntity(entity.getId());
        return controller;
    }

    public static <T extends WindowController & ModeController> T showMode(ApplicationMode mode) {
        MainController mainController = SpringContext.CONTEXT.getBean(MainController.class);
        final T modeController = showWindow(mainController.getDetailPane(), mode.getResource());
        mainController.setMode(mode);
        return modeController;
    }

}
