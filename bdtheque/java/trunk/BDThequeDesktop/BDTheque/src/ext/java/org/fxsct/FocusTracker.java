package org.fxsct;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Platform;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.*;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.util.Duration;

public class FocusTracker {

    private final ObjectProperty<Node> focusedNode = new SimpleObjectProperty<Node>();
    private final ObjectProperty<Scene> subjectScene = new SimpleObjectProperty<Scene>();
    private final BooleanProperty trackFocus = new SimpleBooleanProperty(false);
    private final InvalidationListener focusListener = new InvalidationListener() {

        @Override
        public void invalidated(Observable arg0) {
            setFocusedNode();
        }

    };
    Timeline focusCheckTimer = new Timeline(new KeyFrame(Duration.seconds(1), new EventHandler<ActionEvent>() {

        @Override
        public void handle(ActionEvent arg0) {
            setFocusedNode();
        }

    }));

    FocusTracker() {
        trackFocus.addListener(focusListener);
        subjectScene.addListener(focusListener);
//		Bindings.select(subjectScene, "window", "focused").addListener(focusListener);
    }

    public static Node findFocused(Node e) {
        if (e instanceof Parent) {
            Parent parent = (Parent) e;
            for (Node node : parent.getChildrenUnmodifiable()) {
                node = findFocused(node);
                if (node != null)
                    return node;
            }
        }
        if (e.isFocusTraversable()) {
            if (e.isFocused()) {
                return e;
            }
        }
        return null;
    }

    private void setFocusedNode() {
        if (focusedNode.get() != null) {
            focusedNode.get().focusedProperty().removeListener(focusListener);
        }

        if (subjectScene.get() == null || !trackFocus.get())
            return;
//		System.out.println("FocusTracker.focusListener: 1--------------");
        Scene s = subjectScene.get();
        if (s != null) {
            if (!s.getWindow().isFocused()) {
                focusCheckTimer.playFromStart();
                return;
            }
            Node n = findFocused(s.getRoot());
            try {
                focusedNode.set(n);
            } catch (Throwable t) {

            }
            if (n != null) {
                n.focusedProperty().addListener(focusListener);
            } else {
                Platform.runLater(new Runnable() {

                    @Override
                    public void run() {
                        setFocusedNode();
                    }
                });
            }
        }
    }

    public ReadOnlyObjectProperty<Node> focusedNodeProperty() {
        return focusedNode;
    }

    public ObjectProperty<Scene> subjectSceneProperty() {
        return subjectScene;
    }

    public BooleanProperty trackFocusProperty() {
        return trackFocus;
    }

}
