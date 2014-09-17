/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPickerContent.java
 * Last modified by Tetram, on 2014-09-05T14:32:21CEST
 */

package org.tetram.bdtheque.gui.components;

import javafx.beans.property.StringProperty;
import javafx.event.EventHandler;
import javafx.scene.Node;
import javafx.scene.control.PopupControl;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Region;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewSearchController;
import org.tetram.bdtheque.spring.SpringFxmlLoader;
import org.tetram.bdtheque.utils.ClassLink;
import org.tetram.bdtheque.utils.ClassLinks;

/**
 * Created by Thierry on 10/08/2014.
 */
@ClassLinks({
        @ClassLink(com.sun.javafx.scene.control.skin.ColorPalette.class),
        @ClassLink(com.sun.javafx.scene.control.skin.DatePickerContent.class)
})
public class EntityPickerContent extends Region {

    private final TreeViewSearchController treeViewSearchController;
    private final TreeViewController treeViewController;
    private PopupControl popupControl;

    public EntityPickerContent(EntityPicker entityPicker) {
        treeViewSearchController = SpringFxmlLoader.load("components/treeviewsearch.fxml");
        treeViewController = treeViewSearchController.getTreeViewController();
        treeViewController.setClickToShow(false);
        treeViewController.setOnClickItem(event -> {
            if (event.getClickCount() == 2) {
                event.consume();
                acceptValue(entityPicker);
            }
        });

        treeViewController.filtreProperty().bindBidirectional(entityPicker.filtreProperty());
        treeViewController.modeProperty().bindBidirectional(entityPicker.modeProperty());

        treeViewController.getTreeView().minWidthProperty().bind(this.minWidthProperty());
        treeViewController.getTreeView().prefWidthProperty().bind(this.prefWidthProperty());
        treeViewController.getTreeView().maxWidthProperty().bind(this.maxWidthProperty());
        treeViewController.getTreeView().minHeightProperty().bind(this.minHeightProperty());
        treeViewController.getTreeView().prefHeightProperty().bind(this.prefHeightProperty());
        treeViewController.getTreeView().maxHeightProperty().bind(this.maxHeightProperty());

        final EventHandler<? super KeyEvent> onTextFieldSearchKeyPressed = treeViewSearchController.getTextFieldSearch().getOnKeyPressed();
        treeViewSearchController.getTextFieldSearch().setOnKeyPressed(event -> {
            if (!event.isAltDown() && !event.isControlDown() && !event.isShiftDown() && !event.isMetaDown())
                switch (event.getCode()) {
                    case ESCAPE:
                        event.consume();
                        entityPicker.hide();
                        break;
                    case ENTER:
                        if (!treeViewController.getFindRegistered()) {
                            event.consume();
                            acceptValue(entityPicker);
                        } else
                            onTextFieldSearchKeyPressed.handle(event);
                        break;
                    default:
                        onTextFieldSearchKeyPressed.handle(event);
                }
            else
                onTextFieldSearchKeyPressed.handle(event);
        });

        EventHandler<? super KeyEvent> onTreeViewKeyPressed = treeViewController.getTreeView().getOnKeyPressed();
        treeViewController.getTreeView().setOnKeyPressed(event -> {
            if (!event.isAltDown() && !event.isControlDown() && !event.isShiftDown() && !event.isMetaDown())
                switch (event.getCode()) {
                    case ESCAPE:
                        event.consume();
                        entityPicker.hide();
                        break;
                    case ENTER:
                        if (treeViewController.getSelectedEntity() != null) {
                            event.consume();
                            acceptValue(entityPicker);
                            break;
                        }
                    default:
                        onTreeViewKeyPressed.handle(event);
                }
            else
                onTreeViewKeyPressed.handle(event);
        });

        getChildren().add(treeViewSearchController.getView());
    }

    private void acceptValue(EntityPicker entityPicker) {
        entityPicker.setValue((AbstractDBEntity) treeViewController.getSelectedEntity());
        entityPicker.hide();
    }

    public Node getView() {
        return treeViewSearchController.getView();
    }

    public String getFiltre() {
        return treeViewController.getFiltre();
    }

    public void setFiltre(String filtre) {
        treeViewController.setFiltre(filtre);
    }

    public StringProperty filtreProperty() {
        return treeViewController.filtreProperty();
    }

    public PopupControl getPopupControl() {
        return popupControl;
    }

    public void setPopupControl(PopupControl popupControl) {
        this.popupControl = popupControl;
    }

    public void updateSelection(AbstractDBEntity value) {
        treeViewController.setSelectedEntity(value);
    }

    public void clearFocus() {
        treeViewSearchController.getTextFieldSearch().requestFocus();
    }
}
