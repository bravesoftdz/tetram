package org.fxsct;

import javafx.beans.binding.DoubleBinding;
import javafx.beans.property.*;
import javafx.event.EventHandler;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.shape.Rectangle;
import javafx.stage.Window;
import org.fxsct.locator.LocatorStage;

import java.util.ArrayList;
import java.util.Collections;

import static javafx.beans.binding.Bindings.*;


public class NodeTracker {

    private final LocatorStage locatorStage;
    private final ObjectProperty<Node> node = new SimpleObjectProperty<Node>();
    private final ObjectProperty<Window> subjectStage = new SimpleObjectProperty<Window>();
    DoubleBinding x = selectDouble(subjectStage, "x").add(selectDouble(subjectStage, "scene", "x"));
    DoubleBinding y = selectDouble(subjectStage, "y").add(selectDouble(subjectStage, "scene", "y"));
    private final BooleanProperty trackMouse = new SimpleBooleanProperty(false);
    Rectangle trackArea = new Rectangle() {{
        xProperty().bind(x);
        yProperty().bind(y);
        widthProperty().bind(selectDouble(subjectStage, "scene", "width"));
        heightProperty().bind(selectDouble(subjectStage, "scene", "height"));
        visibleProperty().bind(when(isNull(subjectStage)).then(false).otherwise(trackMouse));
        setOpacity(0.1);
        setOnMouseClicked(new EventHandler<MouseEvent>() {

            @Override
            public void handle(MouseEvent ev) {
                trackMouse.set(false);
            }

        });
        setOnKeyTyped(new EventHandler<KeyEvent>() {

            @Override
            public void handle(KeyEvent ev) {
                trackMouse.set(false);
            }

        });
    }};

    NodeTracker(LocatorStage locatorStage) {
        this.locatorStage = locatorStage;
        trackArea.onMouseMovedProperty().set(new EventHandler<MouseEvent>() {

            @Override
            public void handle(MouseEvent ev) {
                Node n = locateChildAt(subjectStage.get().getScene().getRoot(), ev.getX() - trackArea.getX(), ev.getY() - trackArea.getY());
                if (n != null)
                    node.set(n);
            }
        });
        this.locatorStage.getGlassGroup().addAll(trackArea);
    }

    public ReadOnlyObjectProperty<Node> nodeProperty() {
        return node;
    }

    public ObjectProperty<Window> subjectStageProperty() {
        return subjectStage;
    }

    private Node locateChildAt(Parent p, double x, double y) {
        ArrayList<Node> kids = new ArrayList<Node>(p.getChildrenUnmodifiable());
        Collections.reverse(kids);
        for (Node kid : kids) {
            if (kid.contains(kid.sceneToLocal(x, y))) {
                if (kid instanceof Parent)
                    return locateChildAt((Parent) kid, x, y);
                else
                    return kid;
            }
        }
        return p;
    }

    public BooleanProperty trackMouseProperty() {
        return trackMouse;
    }

}
