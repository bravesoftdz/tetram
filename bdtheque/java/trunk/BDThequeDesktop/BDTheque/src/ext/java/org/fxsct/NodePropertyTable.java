/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * NodePropertyTable.java
 * Last modified by Tetram, on 2014-07-30T12:36:20CEST
 */

/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package org.fxsct;

import javafx.beans.binding.Bindings;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.scene.Node;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.util.Callback;
import javafx.util.Pair;

import java.util.ArrayList;
import java.util.Map.Entry;

/**
 * @author ABSW
 */
public class NodePropertyTable {
    TableView<Pair<String, ObservableValue<?>>> tv;


    public Node getRootNode() {
        if (tv == null) {
            tv = new TableView<Pair<String, ObservableValue<?>>>();
            TableColumn<Pair<String, ObservableValue<?>>, String> propNameCol = new TableColumn<Pair<String, ObservableValue<?>>, String>("Property");
            propNameCol.setCellValueFactory(new Callback<CellDataFeatures<Pair<String, ObservableValue<?>>, String>, ObservableValue<String>>() {

                public ObservableValue<String> call(CellDataFeatures<Pair<String, ObservableValue<?>>, String> p) {
                    return new SimpleStringProperty(p.getValue().getKey());
                }
            });
            propNameCol.setPrefWidth(150);
            propNameCol.setResizable(false);
            TableColumn<Pair<String, ObservableValue<?>>, String> propValueCol = new TableColumn<Pair<String, ObservableValue<?>>, String>("Value");
            propValueCol.setCellValueFactory(new Callback<CellDataFeatures<Pair<String, ObservableValue<?>>, String>, ObservableValue<String>>() {

                public ObservableValue<String> call(CellDataFeatures<Pair<String, ObservableValue<?>>, String> p) {
                    return Bindings.convert(p.getValue().getValue());
                }
            });
            tv.getColumns().add(propNameCol);
            tv.getColumns().add(propValueCol);
            tv.setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY);
            tv.setMinHeight(90);
        }
        return tv;
    }

    public void setNode(Node n) {
        if (n != null) {
            ArrayList<Pair<String, ObservableValue<?>>> props = new ArrayList<Pair<String, ObservableValue<?>>>();
            for (Entry<String, ObservableValue<?>> e : NodeInfo.getProperties(n).entrySet()) {
                props.add(new Pair<String, ObservableValue<?>>(e.getKey(), e.getValue()));
            }
            tv.getItems().setAll(props);
        } else
            tv.getItems().clear();
    }

}
