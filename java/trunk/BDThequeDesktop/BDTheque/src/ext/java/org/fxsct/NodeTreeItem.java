/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package org.fxsct;

import javafx.application.Platform;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.control.TreeItem;

import java.util.ArrayList;
import java.util.List;

/**
 * @author ABSW
 */
class NodeTreeItem extends TreeItem<Node> {
    ListChangeListener<Node> nodeChangeListener = new ListChangeListener<Node>() {

        public void onChanged(Change<? extends Node> change) {
            List<TreeItem<Node>> children = NodeTreeItem.super
                    .getChildren();
            while (change.next()) {
                int replaceSize = Math.min(change.getAddedSize(),
                        change.getRemovedSize());
                for (int i = 0; i < replaceSize; i++) {
                    int absIndex = change.getFrom() + i;
//					((NodeTreeItem) (children.get(absIndex))).disposeAll();
                    Node n = change.getAddedSubList().get(i);
//					System.out.println("initChildren/onChanged(): Replacing node "
//									+ NodeInfo.getBreadCrumbString(n));
                    NodeTreeItem oldItem = (NodeTreeItem) children.set(absIndex, new NodeTreeItem(n));
                    oldItem.disposeAll();
                }
                if (change.getAddedSize() > replaceSize) {
                    for (int i = replaceSize; i < change.getAddedSize(); i++) {
                        int absIndex = change.getFrom() + i;
                        Node n = change.getAddedSubList().get(i);
//						System.out
//								.println("initChildren/onChanged(): Adding node "
//										+ NodeInfo.getBreadCrumbString(n));
                        children.add(absIndex, new NodeTreeItem(n));
                    }
                } else if (change.getRemovedSize() > replaceSize) {
                    int startIndex = change.getFrom() + replaceSize;
                    int removeSize = change.getRemovedSize() - replaceSize;
                    try {
                        List<TreeItem<Node>> removedItems = new ArrayList<TreeItem<Node>>(children.subList(
                                startIndex, startIndex + removeSize));
                        if (removedItems.size() == children.size())
                            children.clear();
                        else
                            children.removeAll(removedItems);
                        for (TreeItem<Node> item : removedItems) {
                            ((NodeTreeItem) item).disposeAll();
                        }
                    } catch (IndexOutOfBoundsException ex) {
                        System.out.println(String.format("NodeTreeItem Error: Tried to remove children from %d to %d but the list only had %d items", startIndex, removeSize, children.size()));
                    }
                }
            }
        }
    };
    private boolean hasInitializedChildren = false;

    NodeTreeItem(Node node) {
        super(node);

        expandedProperty().addListener(new InvalidationListener() {

            public void invalidated(Observable o) {
                if (!isExpanded())
                    disposeChildren();
            }
        });
    }

    @Override
    public ObservableList<TreeItem<Node>> getChildren() {
        Platform.runLater(new Runnable() {

            @Override
            public void run() {
                if (!hasInitializedChildren) {
                    initChildren();
                }
            }
        });
        return super.getChildren();
    }

    @Override
    public boolean isLeaf() {
        if (!hasInitializedChildren) {
            initChildren();
        }
        return !(getValue() instanceof Parent) || ((Parent) getValue()).getChildrenUnmodifiable().isEmpty();
    }

    private List<TreeItem<Node>> buildChildren() {
        ArrayList<TreeItem<Node>> newKids = new ArrayList<TreeItem<Node>>();
        for (Node n : ((Parent) getValue()).getChildrenUnmodifiable()) {
//			System.out.println("buildChildren() "
//					+ NodeInfo.getBreadCrumbString(n));
            newKids.add(new NodeTreeItem(n));
        }
        return newKids;
    }

    private void initChildren() {
        hasInitializedChildren = true;
        if (getValue() instanceof Parent) {
            Parent me = (Parent) getValue();
            super.getChildren().setAll(buildChildren());
            me.getChildrenUnmodifiable().addListener(nodeChangeListener);
        }
    }

    private void disposeAll() {
        disposeChildren();
        dispose();
    }

    private void disposeChildren() {
        for (TreeItem<Node> item : super.getChildren()) {
            item.setExpanded(false);
            ((NodeTreeItem) item).dispose();
        }
    }

    private void dispose() {
        if (getValue() instanceof Parent) {
            Parent me = (Parent) getValue();
            me.getChildrenUnmodifiable().removeListener(nodeChangeListener);
//			disposeChildren();
//			System.out.println("dispose() "	+ NodeInfo.getBreadCrumbString(getValue()));
            super.getChildren().clear();
        }
        hasInitializedChildren = false;
    }

    @Override
    public boolean equals(Object other) {
        if (other == null) {
            return false;
        }
        if (other instanceof NodeTreeItem) {
            return getValue() == ((NodeTreeItem) other).getValue();
        } else
            return false;

    }
}
