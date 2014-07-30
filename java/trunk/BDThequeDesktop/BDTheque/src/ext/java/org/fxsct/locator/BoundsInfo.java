package org.fxsct.locator;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.geometry.BoundingBox;
import javafx.geometry.Bounds;
import javafx.scene.Node;

class BoundsInfo {
    private static final Bounds NULL_BOUNDS = new BoundingBox(0, 0, 0, 0);
    private final DoubleProperty offsetX = new SimpleDoubleProperty(0.0);
    private final DoubleProperty offsetY = new SimpleDoubleProperty(0.0);
    private final ObjectProperty<Node> subjectNode = new SimpleObjectProperty<Node>();
    private final ObjectProperty<Bounds> localBounds = new SimpleObjectProperty<Bounds>();
    private final ObjectProperty<Bounds> layoutBounds = new SimpleObjectProperty<Bounds>();
    ChangeListener<Node> parentListener = new ChangeListener<Node>() {

        @Override
        public void changed(ObservableValue<? extends Node> observable,
                            Node oldValue, Node newValue) {
            removeListeners(oldValue);
            installListeners(newValue);
            boundsListener.invalidated(observable);
        }
    };
    InvalidationListener boundsListener = new InvalidationListener() {

        @Override
        public void invalidated(Observable paramObservable) {
            if (subjectNode.get() != null) {
                Node parent = subjectNode.get().getParent();
                if (parent == null) {
                    parent = subjectNode.get();
                    offsetX.set(0.0);
                    offsetY.set(0.0);
                } else {
                    Bounds parentBounds = parent.localToScene(parent.getBoundsInLocal());
//					System.out.println("BoundsInfo.boundsListener.invalidated: " + parentBounds);
                    offsetX.set(parentBounds.getMinX());
                    offsetY.set(parentBounds.getMinY());
                }
                localBounds.set(subjectNode.get().localToScene(subjectNode.get().getBoundsInLocal()));
                //			localBounds.set(parent.localToScene(subjectNode.get().getBoundsInParent()));
//				layoutBounds.set(parent.localToScene(subjectNode.get().getLayoutBounds()));
                Bounds layout = new BoundingBox(
                        subjectNode.get().getLayoutX(),
                        subjectNode.get().getLayoutY(),
                        subjectNode.get().getLayoutBounds().getWidth(),
                        subjectNode.get().getLayoutBounds().getHeight());
                layoutBounds.set(parent.localToScene(layout));
            } else
                setNullBounds();
        }
    };
    ChangeListener<Node> nodeListener = new ChangeListener<Node>() {

        @Override
        public void changed(
                ObservableValue<? extends Node> obs,
                Node oldNode, Node newNode) {
            removeListeners(oldNode);
            installListeners(newNode);
            boundsListener.invalidated(obs);
        }
    };

    public BoundsInfo() {
        subjectNode.addListener(nodeListener);
    }

    public ObjectProperty<Node> subjectNodeProperty() {
        return subjectNode;
    }

    public ObjectProperty<Bounds> localBoundsProperty() {
        return localBounds;
    }

    public ObjectProperty<Bounds> layoutBoundsProperty() {
        return layoutBounds;
    }

    private void installListeners(Node node) {
        while (node != null) {
            node.parentProperty().addListener(parentListener);
            node.boundsInLocalProperty().addListener(boundsListener);
            node.boundsInParentProperty().addListener(boundsListener);
            node.layoutBoundsProperty().addListener(boundsListener);
            node = node.getParent();
        }
    }

    private void removeListeners(Node node) {
        while (node != null) {
            node.parentProperty().removeListener(parentListener);
            node.boundsInLocalProperty().removeListener(boundsListener);
            node.boundsInParentProperty().removeListener(boundsListener);
            node.layoutBoundsProperty().removeListener(boundsListener);
            node = node.getParent();
        }
    }

    private void setNullBounds() {
        offsetX.set(0.0);
        offsetY.set(0.0);
        localBounds.set(NULL_BOUNDS);
        layoutBounds.set(NULL_BOUNDS);

    }
}
