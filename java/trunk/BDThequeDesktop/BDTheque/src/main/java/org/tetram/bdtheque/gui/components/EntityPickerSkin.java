/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPickerSkin.java
 * Last modified by Thierry, on 2014-08-10T15:11:49CEST
 */

package org.tetram.bdtheque.gui.components;

import com.sun.javafx.scene.control.skin.ComboBoxPopupControl;
import javafx.scene.Node;
import javafx.scene.control.Label;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;

/**
 * Created by Thierry on 10/08/2014.
 */
@SuppressWarnings("HardCodedStringLiteral")
public class EntityPickerSkin extends ComboBoxPopupControl<AbstractDBEntity> {

    private final Label displayNode;
    private EntityTreeView popupContent;

    public EntityPickerSkin(final EntityPicker entityPicker) {
        super(entityPicker, new EntityPickerBehavior(entityPicker));
        displayNode = new Label();
        registerChangeListener(entityPicker.valueProperty(), "VALUE");
    }


    @Override
    protected Node getPopupContent() {
        return getEntityTreeView();
    }

    private EntityTreeView getEntityTreeView(){
        if (popupContent == null) {
            popupContent = new EntityTreeView((EntityPicker) getSkinnable());
            popupContent.setPopupControl(getPopup());
        }
        return popupContent;
    }

    @Override
    public void show() {
        super.show();
        final EntityPicker entityPicker = (EntityPicker) getSkinnable();
        popupContent.updateSelection(entityPicker.getValue());
        popupContent.clearFocus();
    }

    @Override
    protected void handleControlPropertyChanged(String p) {
        super.handleControlPropertyChanged(p);

        if ("SHOWING".equals(p)) {
            if (getSkinnable().isShowing()) {
                show();
            } else {
                hide();
            }
        } else if ("VALUE".equals(p)) {
            updateLabel();
            // Change the current selected color in the grid if ColorPicker value changes
//            if (popupContent != null) {
//                popupContent.updateSelection(getSkinnable().getValue());
//            }
        }

    }

    private void updateLabel() {
        final EntityPicker entityPicker = (EntityPicker) getSkinnable();
        displayNode.setText(entityPicker.getValue().toString());
    }

    @Override
    public Node getDisplayNode() {
        return displayNode;
    }

    public void syncWithAutoUpdate() {
        if (!getPopup().isShowing() && getSkinnable().isShowing()) {
            // Popup was dismissed. Maybe user clicked outside or typed ESCAPE.
            // Make sure EntityPicker button is in sync.
            getSkinnable().hide();
        }
    }

    public TreeViewController getTreeViewController() {
        return getEntityTreeView().getTreeviewController();
    }
}
