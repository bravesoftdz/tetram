package org.fxsct.locator;

import javafx.application.Platform;
import javafx.beans.binding.Bindings;
import javafx.beans.binding.BooleanBinding;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.ObservableList;
import javafx.geometry.Rectangle2D;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;
import javafx.stage.Popup;
import javafx.stage.Screen;
import javafx.stage.Window;

public class LocatorStage {

    private final Group publicGroup = new Group();
    private final Group glassGroup = new Group();
    private final ObjectProperty<Window> parentWindow = new SimpleObjectProperty<Window>();
    private final ObjectProperty<Popup> stage = new SimpleObjectProperty<Popup>();

    private final ChangeListener<Window> parentWindowListener = new ChangeListener<Window>() {

        @Override
        public void changed(ObservableValue<? extends Window> observable,
                            Window oldParent, Window newParent) {
            hide();
            if (newParent != null)
                Platform.runLater(new Runnable() {

                    @Override
                    public void run() {
                        show();
                    }
                });
        }
    };

    public LocatorStage() {
        parentWindow.addListener(parentWindowListener);

//		BindingsTrace.change("LocatorStage.stage.focussed", Bindings.selectBoolean(stage, "focused"), System.out);

    }

    private void show() {
        if (stage.get() != null)
            hide();
        Rectangle2D screenBounds = getScreenBounds();
        Group privateGroup = new Group(publicGroup, glassGroup);
        Rectangle clip = new Rectangle(screenBounds.getMinX(), screenBounds.getMinY(), screenBounds.getWidth(), screenBounds.getHeight());
        privateGroup.setClip(clip);
        // Add an invisible line that spans diagonally accross the all the available screens
        // This seems to force the correct size and position for the stage. Without this other
        // items on the stage are either not visible or they are positioned incorrectly.
        Line propLine = new Line(screenBounds.getMinX(), screenBounds.getMinY(), screenBounds.getMaxX(), screenBounds.getMaxY());
        propLine.setOpacity(0);
        privateGroup.getChildren().add(propLine);
        stage.set(new Popup());
        stage.get().getContent().setAll(privateGroup);
        stage.get().show(parentWindow.get(), screenBounds.getMinX(), screenBounds.getMinY());
        stage.get().setHideOnEscape(false);
    }

    private void hide() {
        if (stage.get() != null) {
            stage.get().hide();
            stage.set(null);
        }
    }

    private Rectangle2D getScreenBounds() {
        double minX = 0.0;
        double minY = 0.0;
        double maxX = 0.0;
        double maxY = 0.0;
        for (Screen s : Screen.getScreens()) {
            Rectangle2D b = s.getBounds();
            minX = Math.min(minX, b.getMinX());
            minY = Math.min(minY, b.getMinY());
            maxX = Math.max(maxX, b.getMaxX());
            maxY = Math.max(maxY, b.getMaxY());
        }
        return new Rectangle2D(minX, minY, maxX - minX, maxY - minY);
    }

    public ObservableList<Node> getContent() {
        return publicGroup.getChildren();
    }

    public ObservableList<Node> getGlassGroup() {
        return glassGroup.getChildren();
    }

    public ObjectProperty<Window> parentWindowProperty() {
        return parentWindow;
    }

    public BooleanBinding focusedProperty() {
        return Bindings.selectBoolean(stage, "focused");
    }
}


