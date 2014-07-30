package org.fxsct.locator;

import javafx.beans.binding.BooleanBinding;
import javafx.beans.binding.DoubleBinding;
import javafx.beans.binding.ObjectBinding;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.shape.StrokeType;
import javafx.stage.Window;

import static javafx.beans.binding.Bindings.*;

/*
 * TODO: Layout bounds - show anchor point as 'x' and line to 0,0 Bounds in
 * parent (visual bounds) Local bounds siblings ?
 */

public class NodeVisualizer {

    //	private static final String LOCATOR_CSS = NodeLocator.class.getResource(
//			"NodeLocator.css").toExternalForm();
    private final ObjectProperty<Node> subjectNode = new SimpleObjectProperty<Node>();
    private final ObjectBinding<Scene> subjectScene = select(subjectNode, "scene");
    private final ObjectBinding<Window> subjectWindow = select(subjectScene, "window");
    DoubleBinding offsetX = selectDouble(subjectWindow, "x")
            .add(selectDouble(subjectScene, "x"));
    DoubleBinding offsetY = selectDouble(subjectWindow, "y")
            .add(selectDouble(subjectScene, "y"));
    private final NodeLocator locator = new NodeLocator() {{
        subjectNodeProperty().bind(subjectNode);
    }};
    private final ObservableList<NodeLocator> childLocators = FXCollections
            .observableArrayList();
    private final Group childGroup = new Group();
    private final Group visGroup = new Group(locator.getContent(), childGroup) {{
        layoutXProperty().bind(offsetX);
        layoutYProperty().bind(offsetY);
        visibleProperty().bind(isNotNull(subjectNode));
    }};
    private final BooleanBinding fill = selectBoolean(subjectWindow, "focused").not();
    private final DoubleBinding opacity = when(fill).then(0.2).otherwise(0.0);
    private final LocatorStage locatorStage;
    private final ListChangeListener<Node> childChanger = new ListChangeListener<Node>() {

        public void onChanged(Change<? extends Node> change) {
            while (change.next()) {
                for (Node n : change.getRemoved())
                    removeChild(change.getFrom());
                for (int index = 0; index < change.getAddedSize(); ++index)
                    addChild(change.getFrom() + index, change.getAddedSubList()
                            .get(index));
            }
        }
    };
    private ChangeListener<Node> nodeChanger = new ChangeListener<Node>() {

        public void changed(ObservableValue<? extends Node> ov, Node oldNode,
                            Node newNode) {
            if (oldNode != null)
                cleanup(oldNode);
            if (newNode != null)
                configure();
        }
    };

    public NodeVisualizer() {
        this(null);
    }

    public NodeVisualizer(LocatorStage locStage) {
        if (locStage == null) {
            locatorStage = new LocatorStage() {{
                parentWindowProperty().bind(subjectWindow);
            }};
        } else {
            locatorStage = locStage;
        }
        locatorStage.getContent().setAll(visGroup);
        locator.fillOpacityProperty().bind(opacity);
        subjectNode.addListener(nodeChanger);
    }

    private void removeChild(int index) {
        NodeLocator loc = childLocators.remove(index);
        loc.subjectNodeProperty().set(null);
        childGroup.getChildren().remove(loc.getContent());
    }

    private void addChild(int index, final Node n) {
        NodeLocator loc = new NodeLocator() {{
            strokeTypeProperty().set(StrokeType.INSIDE);
            strokePaintProperty().set(Color.BLUE);
            subjectNodeProperty().set(n);
            this.fillOpacityProperty().bind(opacity);

        }};
        childLocators.add(index, loc);
        childGroup.getChildren().add(index, loc.getContent());
    }

    private void removeChildLocators() {
        for (NodeLocator loc : childLocators)
            loc.subjectNodeProperty().set(null);
        childLocators.clear();
        childGroup.getChildren().clear();
    }

    public ObjectProperty<Node> subjectNodeProperty() {
        return subjectNode;
    }

    private void cleanup(Node oldNode) {
        if (oldNode instanceof Parent) {
            Parent p = (Parent) oldNode;
            p.getChildrenUnmodifiable().removeListener(childChanger);
        }
        removeChildLocators();
    }

    private void configure() {
        Node newNode = subjectNode.get();

        if (newNode instanceof Parent) {
            Parent p = (Parent) newNode;
            p.getChildrenUnmodifiable().addListener(childChanger);
            int index = 0;
            for (Node n : p.getChildrenUnmodifiable())
                addChild(index++, n);
        }
    }
}
