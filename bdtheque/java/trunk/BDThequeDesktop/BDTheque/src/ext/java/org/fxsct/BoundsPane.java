/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package org.fxsct;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.geometry.Bounds;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;

import java.text.DecimalFormat;

/**
 * @author ABSW
 */
public class BoundsPane {

    GridPane gp;
    Label xTitle = new Label("X");
    Label yTitle = new Label("Y");
    Label wTitle = new Label("Width");
    Label hTitle = new Label("Height");
    BoundsLabels local = new BoundsLabels("Local");
    BoundsLabels parent = new BoundsLabels("Parent");
    BoundsLabels layout = new BoundsLabels("Layout");
    DecimalFormat fmt = new DecimalFormat("###0.00");
    ObjectProperty<Node> subjectNode = new SimpleObjectProperty<Node>();

    private void setNode(Node n) {
        local.bounds.unbind();
        parent.bounds.unbind();
        layout.bounds.unbind();
        if (n != null) {
            local.bounds.bind(n.boundsInLocalProperty());
            parent.bounds.bind(n.boundsInParentProperty());
            layout.bounds.bind(n.layoutBoundsProperty());
        }
    }

    Node getContentNode() {
        if (gp == null) {
            gp = new GridPane();
            gp.getColumnConstraints().setAll(
                    new ColumnConstraints(40, 40, 80),
                    new ColumnConstraints(40, 40, 80),
                    new ColumnConstraints(40, 40, 80),
                    new ColumnConstraints(40, 40, 80),
                    new ColumnConstraints(40, 40, 80)
            );
            gp.getStyleClass().add("fxsct-bounds-grid");
            gp.getChildren().addAll(xTitle, yTitle, wTitle, hTitle);
            gp.getChildren().addAll(local.getLabels());
            gp.getChildren().addAll(parent.getLabels());
            gp.getChildren().addAll(layout.getLabels());
            xTitle.getStyleClass().add("fxsct-constraint-header");
            yTitle.getStyleClass().add("fxsct-constraint-header");
            wTitle.getStyleClass().add("fxsct-constraint-header");
            hTitle.getStyleClass().add("fxsct-constraint-header");
            GridPane.setConstraints(xTitle, 1, 0, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(yTitle, 2, 0, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(wTitle, 3, 0, 1, 1, HPos.CENTER, VPos.CENTER);
            GridPane.setConstraints(hTitle, 4, 0, 1, 1, HPos.CENTER, VPos.CENTER);
            local.setGridRow(1);
            parent.setGridRow(2);
            layout.setGridRow(3);
            subjectNode.addListener(new InvalidationListener() {

                public void invalidated(Observable o) {
                    setNode(subjectNode.get());
                }
            });
            setNode(subjectNode.get());
        }

        return gp;
    }

    ObjectProperty<Node> subjectNodeProperty() {
        return subjectNode;
    }

    private class BoundsLabels {

        Label name = new Label();
        Label x = new Label();
        Label y = new Label();
        Label w = new Label();
        Label h = new Label();
        ObjectProperty<Bounds> bounds = new SimpleObjectProperty<Bounds>();

        BoundsLabels(String title) {
            name.setText(title);
            name.getStyleClass().add("fxsct-constraint-header");
            bounds.addListener(new InvalidationListener() {

                public void invalidated(Observable o) {
                    Bounds b = bounds.get();
                    if (b == null) {
                        x.setText("-");
                        y.setText("-");
                        w.setText("-");
                        h.setText("-");
                    } else {
                        x.setText(fmt.format(b.getMinX()));
                        y.setText(fmt.format(b.getMinY()));
                        w.setText(fmt.format(b.getWidth()));
                        h.setText(fmt.format(b.getHeight()));
                        x.setText(fmt.format(bounds.get().getMinX()));
                    }
                }
            });
        }

        Label[] getLabels() {
            return new Label[]{name, x, y, w, h};
        }

        void setGridRow(int rowNo) {
            GridPane.setConstraints(name, 0, rowNo, 1, 1, HPos.LEFT, VPos.CENTER);
            GridPane.setConstraints(x, 1, rowNo, 1, 1, HPos.RIGHT, VPos.CENTER);
            GridPane.setConstraints(y, 2, rowNo, 1, 1, HPos.RIGHT, VPos.CENTER);
            GridPane.setConstraints(w, 3, rowNo, 1, 1, HPos.RIGHT, VPos.CENTER);
            GridPane.setConstraints(h, 4, rowNo, 1, 1, HPos.RIGHT, VPos.CENTER);
        }
    }
}
