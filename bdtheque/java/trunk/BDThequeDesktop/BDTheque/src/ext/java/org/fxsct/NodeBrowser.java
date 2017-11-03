package org.fxsct;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.ObservableList;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.control.TreeCell;
import javafx.scene.control.TreeItem;
import javafx.scene.control.TreeView;
import javafx.util.Callback;

import java.util.List;

public class NodeBrowser {

    private final TreeView<Node> nodeTree = new TreeView<Node>() {

        {
            this.setEditable(false);
            this.setCellFactory(new Callback<TreeView<Node>, TreeCell<Node>>() {

                public TreeCell<Node> call(TreeView<Node> p) {
                    return new NodeTreeCell();
                }
            });

        }
    };
    private final ObjectProperty<Node> selectedNode = new SimpleObjectProperty<Node>();

    public NodeBrowser() {
        nodeTree.getSelectionModel().getSelectedItems().addListener(new InvalidationListener() {

            public void invalidated(Observable o) {
                ObservableList<TreeItem<Node>> selected = nodeTree.getSelectionModel().getSelectedItems();
                if (selected.isEmpty()) {
                    selectedNode.set(null);
                } else {
                    selectedNode.set(selected.get(0).getValue());
                }
            }
        });
    }

    public ReadOnlyObjectProperty<Node> selectedNodeProperty() {
        return selectedNode;
    }

    public Parent getViewNode() {
        return nodeTree;
    }

    Node getSelectedNode() {
        return selectedNode.get();
    }

    private TreeItem<Node> findChild(TreeItem<Node> parent, Node node) {
        for (TreeItem<Node> c : parent.getChildren())
            if (c.getValue() == node)
                return c;
        return null;
    }

    public void scrollTo(Node node) {
        if (node == null)
            return;
        List<Node> elements = NodeInfo.getBreadCrumbElements(node);
        TreeItem<Node> currentItem = nodeTree.getRoot();
        if (elements.get(0) != currentItem.getValue())
            return;
        for (int i = 1; i < elements.size(); i++) {
            currentItem = findChild(currentItem, elements.get(i));
            if (currentItem == null)
                return;
        }
        nodeTree.getSelectionModel().select(currentItem);
        nodeTree.scrollTo(nodeTree.getSelectionModel().getSelectedIndex());
    }

    public void setRootNode(Node n) {
        nodeTree.setRoot(new NodeTreeItem(n));
    }

}
