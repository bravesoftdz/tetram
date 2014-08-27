/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * TreeViewSearchController.java
 * Last modified by Tetram, on 2014-08-27T10:33:30CEST
 */

package org.tetram.bdtheque.gui.controllers.includes;

import javafx.beans.property.DoubleProperty;
import javafx.beans.property.ReadOnlyDoubleProperty;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import javafx.scene.control.TreeTableView;
import javafx.scene.layout.BorderPane;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

/**
 * Created by Tetram on 27/08/2014.
 */
@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/components/treeviewsearch.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/components/treeview.css")
})
public class TreeViewSearchController extends WindowController {

    @FXML
    private BorderPane containerPane;
    @FXML
    private TreeViewController treeViewController;
    @FXML
    private TextField tfSearch;

    @FXML
    public void initialize() {
        treeViewController.registerSearchableField(tfSearch);
    }

    public TreeViewController getTreeViewController() {
        return treeViewController;
    }

    public TextField getTextFieldSearch() {
        return tfSearch;
    }

    private TreeTableView<AbstractEntity> getTreeView() {
        return treeViewController.getTreeView();
    }

    public ReadOnlyDoubleProperty widthProperty() {
        return getTreeView().widthProperty();
    }

    public ReadOnlyDoubleProperty heightProperty() {
        return getTreeView().heightProperty();
    }

    public DoubleProperty prefWidthProperty() {
        return getTreeView().prefWidthProperty();
    }

    public DoubleProperty prefHeightProperty() {
        return getTreeView().prefHeightProperty();
    }

    public DoubleProperty minWidthProperty() {
        return getTreeView().minWidthProperty();
    }

    public DoubleProperty minHeightProperty() {
        return getTreeView().minHeightProperty();
    }

    public DoubleProperty maxWidthProperty() {
        return getTreeView().maxWidthProperty();
    }

    public DoubleProperty maxHeightProperty() {
        return getTreeView().maxHeightProperty();
    }

}
