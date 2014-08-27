/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPickerTreeView.java
 * Last modified by Tetram, on 2014-08-27T10:47:59CEST
 */

package org.tetram.bdtheque.gui.components;

import javafx.scene.control.PopupControl;
import javafx.scene.layout.Region;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;
import org.tetram.bdtheque.spring.SpringFxmlLoader;

/**
 * Created by Thierry on 10/08/2014.
 */
public class EntityPickerTreeView extends Region {

    private final TreeViewController treeviewController;
    private PopupControl popupControl;

    public EntityPickerTreeView(EntityPicker entityPicker) {
        treeviewController = SpringFxmlLoader.load("components/treeview.fxml");
        treeviewController.minWidthProperty().bind(entityPicker.getEditor().widthProperty());
        treeviewController.setClickToShow(false);
        treeviewController.setOnClickItem(event -> {
            if (event.getClickCount() == 2) {
                event.consume();
                entityPicker.setValue((AbstractDBEntity) treeviewController.getSelectedEntity());
                entityPicker.hide();
            }
        });
        getChildren().add(treeviewController.getTreeView());
    }

    public void setPopupControl(PopupControl popupControl) {
        this.popupControl = popupControl;
    }

    public void updateSelection(AbstractDBEntity value) {
        treeviewController.setSelectedEntity(value);
    }

    public void clearFocus() {
        treeviewController.getTreeView().requestFocus();
    }

    public TreeViewController getTreeviewController() {
        return treeviewController;
    }
}
