/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package org.fxsct;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.geometry.HPos;
import javafx.geometry.Orientation;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Region;

import java.text.DecimalFormat;

/**
 * @author ABSW
 */
public class ConstraintsPane {

    private final ObjectProperty<Node> subjectNode = new SimpleObjectProperty<Node>();
    private final Label minTitle = new Label("Min");
    private final Label prefTitle = new Label("Pref");
    private final Label maxTitle = new Label("Max");
    private final Label wTitle = new Label("Width");
    private final Label hTitle = new Label("Height");
    private final Label minWidthValue = new Label("-");
    private final Label prefWidthValue = new Label("-");
    private final Label maxWidthValue = new Label("-");
    private final Label minHeightValue = new Label("-");
    private final Label prefHeightValue = new Label("-");
    private final Label maxHeightValue = new Label("-");
    private final InvalidationListener nodeListener = new InvalidationListener() {

        @Override
        public void invalidated(Observable paramObservable) {
            Node n = subjectNode.get();
            if (n == null) {
                minWidthValue.setText("-");
                prefWidthValue.setText("-");
                maxWidthValue.setText("-");
                minHeightValue.setText("-");
                prefHeightValue.setText("-");
                maxHeightValue.setText("-");
            } else if (n.getContentBias() == Orientation.HORIZONTAL) {
                double wMin = n.minWidth(Region.USE_COMPUTED_SIZE);
                double wPref = n.prefWidth(Region.USE_COMPUTED_SIZE);
                double wMax = n.maxWidth(Region.USE_COMPUTED_SIZE);

                minWidthValue.setText(fmt.format(wMin));
                prefWidthValue.setText(fmt.format(wPref));

                maxWidthValue.setText(wMax == Double.MAX_VALUE ? "INF" : fmt.format(wMax));
                minHeightValue.setText(fmt.format(n.minHeight(wMin)));
                prefHeightValue.setText(fmt.format(n.prefHeight(wPref)));
                double hMax = n.maxHeight(wMax);
                maxHeightValue.setText(hMax == Double.MAX_VALUE ? "INF" : fmt.format(hMax));
            } else if (n.getContentBias() == Orientation.VERTICAL) {
                double hMin = n.minHeight(Region.USE_COMPUTED_SIZE);
                double hPref = n.prefHeight(Region.USE_COMPUTED_SIZE);
                double hMax = n.maxHeight(Region.USE_COMPUTED_SIZE);

                minHeightValue.setText(fmt.format(hMin));
                prefHeightValue.setText(fmt.format(hPref));
                maxHeightValue.setText(hMax == Double.MAX_VALUE ? "INF" : fmt.format(hMax));
                minWidthValue.setText(fmt.format(n.minWidth(hMin)));
                prefWidthValue.setText(fmt.format(n.prefWidth(hPref)));
                double wMax = n.maxWidth(hMax);
                maxWidthValue.setText(wMax == Double.MAX_VALUE ? "INF" : fmt.format(wMax));
            } else {
                minHeightValue.setText(fmt.format(n.minHeight(Region.USE_COMPUTED_SIZE)));
                prefHeightValue.setText(fmt.format(n.prefHeight(Region.USE_COMPUTED_SIZE)));
                double hMax = n.maxHeight(Region.USE_COMPUTED_SIZE);
                maxHeightValue.setText(hMax == Double.MAX_VALUE ? "INF" : fmt.format(hMax));
                minWidthValue.setText(fmt.format(n.minWidth(Region.USE_COMPUTED_SIZE)));
                prefWidthValue.setText(fmt.format(n.prefWidth(Region.USE_COMPUTED_SIZE)));
                double wMax = n.maxWidth(Region.USE_COMPUTED_SIZE);
                maxWidthValue.setText(wMax == Double.MAX_VALUE ? "INF" : fmt.format(wMax));
            }
        }
    };
    DecimalFormat fmt = new DecimalFormat("###0.00");
    private GridPane gp;

    Node getContentNode() {
        if (gp == null) {
            gp = new GridPane();
            gp.getColumnConstraints().setAll(
                    new ColumnConstraints(40, 40, 40),
                    new ColumnConstraints(40, 60, 100),
                    new ColumnConstraints(40, 60, 100),
                    new ColumnConstraints(40, 60, 100)
            );
            gp.getStyleClass().add("fxsct-bounds-grid");
            gp.getChildren().addAll(minTitle, prefTitle, maxTitle);
            gp.getChildren().addAll(wTitle, minWidthValue, prefWidthValue, maxWidthValue);
            gp.getChildren().addAll(hTitle, minHeightValue, prefHeightValue, maxHeightValue);
            minTitle.getStyleClass().add("fxsct-constraint-header");
            prefTitle.getStyleClass().add("fxsct-constraint-header");
            maxTitle.getStyleClass().add("fxsct-constraint-header");
            wTitle.getStyleClass().add("fxsct-constraint-header");
            hTitle.getStyleClass().add("fxsct-constraint-header");
            GridPane.setConstraints(minTitle, 1, 0, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(prefTitle, 2, 0, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(maxTitle, 3, 0, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(wTitle, 0, 1, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(minWidthValue, 1, 1, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(prefWidthValue, 2, 1, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(maxWidthValue, 3, 1, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(hTitle, 0, 2, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(minHeightValue, 1, 2, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(prefHeightValue, 2, 2, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(maxHeightValue, 3, 2, 1, 1, HPos.CENTER, VPos.CENTER);

            subjectNode.addListener(nodeListener);
        }

        return gp;
    }

    public ObjectProperty<Node> subjectNodeProperty() {
        return subjectNode;
    }
}
