/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package org.fxsct.locator;

import javafx.animation.Transition;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.geometry.BoundingBox;
import javafx.geometry.Bounds;
import javafx.scene.Node;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.StrokeType;
import javafx.util.Duration;

/**
 * @author ABSW
 */
class BoundsLocator {

    private static final Duration ANIMATE_DURATION = Duration.millis(300f);
    private final Transition transition = new Transition() {

        {
            this.setCycleDuration(ANIMATE_DURATION);
        }

        @Override
        protected void interpolate(double progress) {
            if (bounds.get() != null)
                setBorderPosition(
                        interpolateVal(prevBounds.getMinX(), bounds.get().getMinX(), progress),
                        interpolateVal(prevBounds.getMinY(), bounds.get().getMinY(), progress),
                        interpolateVal(prevBounds.getWidth(), bounds.get().getWidth(), progress),
                        interpolateVal(prevBounds.getHeight(), bounds.get().getHeight(), progress));
            else
                transition.stop();
        }
    };

    private static final Bounds HIDDEN = new BoundingBox(0, 0, 0, 0);
    private final ObjectProperty<Bounds> bounds = new SimpleObjectProperty<Bounds>(HIDDEN);
    private final Rectangle border = new Rectangle();
    private Bounds prevBounds;

    private final ChangeListener<Bounds> boundsChanger = new ChangeListener<Bounds>() {

        public void changed(ObservableValue<? extends Bounds> ov, Bounds oldBounds, final Bounds newBounds) {
            if (newBounds != null) {
                if (oldBounds != null)
                    prevBounds = new BoundingBox(border.getX(), border.getY(), border.getWidth(), border.getHeight());
                // transition.playFromStart();
                if (bounds.get() != null)
                    setBorderPosition(bounds.get().getMinX(), bounds.get().getMinY(), bounds.get().getWidth(), bounds.get().getHeight());
            }
        }
    };

    BoundsLocator(Bounds initialBounds) {
        prevBounds = initialBounds;
        bounds.set(initialBounds);
        bounds.addListener(boundsChanger);
    }

    BoundsLocator() {
        this(HIDDEN);
    }

    private static final double interpolateVal(double v1, double v2, double progress) {
        return v1 + (v2 - v1) * progress;
    }

    private void setBorderPosition(double x, double y, double w, double h) {
        border.setX(x);
        border.setY(y);
        border.setWidth(w);
        border.setHeight(h);
    }

    Node getLocatorNode() {
        return border;
    }

    public void setStyle(String style) {
        border.setStyle(style);
    }

    public ObjectProperty<Bounds> boundsProperty() {
        return bounds;
    }


    public ObjectProperty<StrokeType> strokeTypeProperty() {
        return border.strokeTypeProperty();
    }

    public ObjectProperty<Paint> strokeProperty() {
        return border.strokeProperty();
    }

    public ObjectProperty<Paint> fillProperty() {
        return border.fillProperty();
    }

    public DoubleProperty opacityProperty() {
        return border.opacityProperty();
    }

}
