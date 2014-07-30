package org.fxsct;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.util.Callback;
import javafx.util.Pair;

import java.util.Comparator;
import java.util.LinkedList;

public class IdPane {

    private final ObjectProperty<Scene> subjectScene = new SimpleObjectProperty<Scene>();
    private final ObjectProperty<Node> selectedNode = new SimpleObjectProperty<Node>();
    private ListView<Pair<String, Node>> lv;

    public Node getContent() {
        if (lv == null) {
            lv = new ListView<Pair<String, Node>>();
            lv.setCellFactory(new Callback<ListView<Pair<String, Node>>, ListCell<Pair<String, Node>>>() {

                @Override
                public ListCell<Pair<String, Node>> call(ListView<Pair<String, Node>> param) {
                    return new ListCell<Pair<String, Node>>() {
                        @Override
                        protected void updateItem(Pair<String, Node> item, boolean empty) {
                            super.updateItem(item, empty);
                            if (!empty && item != null)
                                setText(item.getKey());
                            else
                                setText("");
                        }

                    };
                }
            });
            subjectScene.addListener(new InvalidationListener() {

                @Override
                public void invalidated(Observable paramObservable) {
                    refresh();
                }
            });

            lv.getSelectionModel().selectedItemProperty().addListener(new InvalidationListener() {

                @Override
                public void invalidated(Observable arg0) {
                    Pair<String, Node> selected = lv.getSelectionModel().getSelectedItem();
                    if (selected != null)
                        selectedNode.set(selected.getValue());
                }
            });
            refresh();
        }
        return lv;
    }

    public void refresh() {
        if (lv == null || subjectScene.get() == null)
            return;
        lv.getItems().clear();
        LinkedList<Node> nodes = new LinkedList<Node>();
        nodes.addAll(subjectScene.get().getRoot().getChildrenUnmodifiable());
        Node n;
        while ((n = nodes.poll()) != null) {
            if (n.getId() != null && !n.getId().isEmpty()) {
                lv.getItems().add(new Pair<String, Node>(n.getId(), n));
            }
            if (n instanceof Parent)
                nodes.addAll(((Parent) n).getChildrenUnmodifiable());
        }
        FXCollections.sort(lv.getItems(), new Comparator<Pair<String, Node>>() {

            @Override
            public int compare(Pair<String, Node> o1, Pair<String, Node> o2) {
                return o1.getKey().compareToIgnoreCase(o2.getKey());
            }
        });
    }


    public ObjectProperty<Scene> subjectSceneProperty() {
        return subjectScene;
    }

    public ReadOnlyObjectProperty<Node> selectedNodeProperty() {
        return selectedNode;
    }


}
