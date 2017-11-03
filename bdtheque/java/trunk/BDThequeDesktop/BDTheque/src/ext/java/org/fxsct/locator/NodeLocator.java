package org.fxsct.locator;

import javafx.beans.property.DoubleProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.Paint;
import javafx.scene.shape.SVGPath;
import javafx.scene.shape.StrokeType;


class NodeLocator {
    private static final String LOCAL_STYLE =
            "-fx-stroke-width: 1px;    ";

    private static final String LAYOUT_STYLE =
            "-fx-stroke-width: 1px;    " +
                    "-fx-stroke-dash-array: 3 3;" +
                    "-fx-stroke-dash-offset: 2; ";

    private final ObjectProperty<StrokeType> strokeType = new SimpleObjectProperty<StrokeType>(StrokeType.OUTSIDE);
    private final ObjectProperty<Paint> paint = new SimpleObjectProperty<Paint>(Color.RED);
    private BoundsLocator localRect = new BoundsLocator() {{
        setStyle(LOCAL_STYLE);
//		getLocatorNode().getStyleClass().add("bounds-in-local");
        boundsProperty().bind(bounds.localBoundsProperty());
        this.strokeTypeProperty().bind(strokeType);
        this.strokeProperty().bind(paint);
        this.fillProperty().set(Color.TRANSPARENT);
    }};
    private BoundsLocator layoutRect = new BoundsLocator() {{
        setStyle(LAYOUT_STYLE);
        boundsProperty().bind(bounds.layoutBoundsProperty());
        this.strokeTypeProperty().bind(strokeType);
        this.strokeProperty().bind(paint);
        this.fillProperty().set(Color.TRANSPARENT);
    }};
    private final SVGPath anchor = new SVGPath() {{
        setContent("M0,4 L-4,0 L4,0 L0,-4 Z");
        fillProperty().bind(paint);
    }};
    private final Group locatorGroup = new Group() {{
        getChildren().addAll(anchor, fillRect.getLocatorNode(), localRect.getLocatorNode(), layoutRect.getLocatorNode());
    }};
    private final DoubleProperty fillOpacity = new SimpleDoubleProperty(0.2);
    private BoundsLocator fillRect = new BoundsLocator() {{
        this.fillProperty().bind(paint);
        this.opacityProperty().bind(fillOpacity);
        this.boundsProperty().bind(bounds.localBoundsProperty());
    }};
    private final ObjectProperty<Node> subjectNode = new SimpleObjectProperty<Node>();
    private final BoundsInfo bounds = new BoundsInfo() {{
        subjectNodeProperty().bind(subjectNode);
    }};

    public ObjectProperty<StrokeType> strokeTypeProperty() {
        return strokeType;
    }

    public ObjectProperty<Paint> strokePaintProperty() {
        return paint;
    }

    public DoubleProperty fillOpacityProperty() {
        return fillOpacity;
    }

    public ObjectProperty<Node> subjectNodeProperty() {
        return subjectNode;
    }

    public Group getContent() {
        return locatorGroup;
    }

}
