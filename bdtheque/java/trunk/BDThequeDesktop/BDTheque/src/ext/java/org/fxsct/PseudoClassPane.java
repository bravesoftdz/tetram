/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package org.fxsct;

import javafx.beans.binding.BooleanExpression;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.FlowPane;
import javafx.util.Pair;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * @author ABSW
 */
public class PseudoClassPane {
    private static final List<Pair<String, String>> pseudoClasses = Arrays.asList(
            pseudo("disabled"), pseudo("focussed"), pseudo("hover"), pseudo("pressed"), pseudo("show-mnemonic"),
            pseudo("selected"), pseudo("armed"), pseudo("cancel", "cancelButton"), pseudo("default", "defaultButton"),
            pseudo("empty"), pseudo("filled"), pseudo("selected"), pseudo("odd"), pseudo("even"),
            pseudo("determinate"), pseudo("indeterminate"), pseudo("visited"),
            pseudo("vertical"), pseudo("horizontal"), pseudo("showing"), pseudo("openvertically"),
            pseudo("top"), pseudo("right"), pseudo("bottom"), pseudo("left"),
            pseudo("cell-selection"), pseudo("row-selection"),
            pseudo("multiline"), pseudo("editable"), pseudo("read-only"),
            pseudo("expanded"), pseudo("collapsed")


    );
    private FlowPane flow = new FlowPane();

    private static Pair<String, String> pseudo(String psClass, String prop) {
        return new Pair<String, String>(psClass, prop);
    }
    // Pseudo Classes:
    // Node: disabled, focused, hover, pressed, show-mnemonic
    // ButtonBase: armed
    // Button: cancel, default
    // Cell: empty, filled, selected
    // IndexedCell: even, odd
    // Checkbox: selected, determinate, indeterminate
    // Hyperlink: visited
    // ListView: vertical, horizontal
    // Menu: showing
    // MenuButton: openvertically
    // TabPane: top, right, bottom, left
    // TableView: cell-selection, row-selection
    // TextArea: multiline
    // TextInputControl: editable, readonly
    // TitledPane: expanded, collapsed

    private static Pair<String, String> pseudo(String psClass) {
        return new Pair<String, String>(psClass, psClass);
    }

    private List<Node> buildPseudoClasses(Node n) {
        flow.getStyleClass().add("fxct-pseudoclass-flow");
        ArrayList<Node> nodes = new ArrayList<Node>();
        for (Pair<String, String> pair : pseudoClasses) {
            try {
                BooleanExpression prop = NodeInfo.getProperty(n, pair.getValue());
                if (prop != null) {
                    Label l = new Label(":" + pair.getKey());
                    l.getStyleClass().add("fxsct-pseudoclass-label");
                    l.disableProperty().bind(prop.not());
                    nodes.add(l);
                }
            } catch (ClassCastException ex) {
            }
        }
        return nodes;
    }

    public void setNode(Node n) {
        if (n == null)
            flow.getChildren().clear();
        else
            flow.getChildren().setAll(buildPseudoClasses(n));
    }

    public Node getContentNode() {
        return flow;
    }
}
