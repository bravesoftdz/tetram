/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPickerSkin.java
 * Last modified by Tetram, on 2014-08-27T14:32:29CEST
 */

package org.tetram.bdtheque.gui.components;

import com.sun.javafx.scene.control.skin.ComboBoxListViewSkin;
import com.sun.javafx.scene.control.skin.ComboBoxPopupControl;
import javafx.css.PseudoClass;
import javafx.scene.Node;
import javafx.scene.control.TextField;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;

/**
 * Created by Thierry on 10/08/2014.
 */
@SuppressWarnings("HardCodedStringLiteral")
public class EntityPickerSkin extends ComboBoxPopupControl<AbstractDBEntity> {

    private static PseudoClass CONTAINS_FOCUS_PSEUDOCLASS_STATE = PseudoClass.getPseudoClass("contains-focus");
    private final EntityPicker entityPicker;
    private TextField textField;
    private TextField displayNode;
    private EntityPickerContent popupContent;


    public EntityPickerSkin(final EntityPicker entityPicker) {
        super(entityPicker, new EntityPickerBehavior(entityPicker));

        this.entityPicker = entityPicker;
        this.textField = getEditableInputNode();
        // Fix for RT-29565. Without this the textField does not have a correct
        // pref width at startup, as it is not part of the scenegraph (and therefore
        // has no pref width until after the first measurements have been taken).
        if (this.textField != null) {
            getChildren().add(textField);
        }

        this.entityPicker.focusedProperty().addListener((ov, t, hasFocus) -> {
            ((ComboBoxListViewSkin.FakeFocusTextField) textField).setFakeFocus(hasFocus);
        });

        registerChangeListener(entityPicker.valueProperty(), "VALUE");
    }

    @Override
    protected Node getPopupContent() {
        return getEntityTreeView();
    }

    private EntityPickerContent getEntityTreeView() {
        if (popupContent == null) {
            popupContent = new EntityPickerContent((EntityPicker) getSkinnable());
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
    protected void focusLost() {
        // do nothing
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
            updateDisplayNode();
            // Change the current selected color in the grid if ColorPicker value changes
//            if (popupContent != null) {
//                popupContent.updateSelection(getSkinnable().getValue());
//            }
        }

    }

    private TextField getEditableInputNode() {
        if (textField != null) return textField;

        textField = entityPicker.getEditor();
        textField.focusTraversableProperty().bindBidirectional(entityPicker.focusTraversableProperty());
        textField.promptTextProperty().bind(entityPicker.promptTextProperty());

        textField.focusedProperty().addListener((ov, t, hasFocus) -> {
            entityPicker.getProperties().put("FOCUSED", hasFocus);
            if (!hasFocus) {
                pseudoClassStateChanged(CONTAINS_FOCUS_PSEUDOCLASS_STATE, false);
            } else {
                pseudoClassStateChanged(CONTAINS_FOCUS_PSEUDOCLASS_STATE, true);
            }
        });

        getTreeViewController().registerSearchableField(textField);
        textField.setOnKeyTyped(event -> {
            if (!event.getCharacter().isEmpty()) show();
        });

        return textField;
    }

    private void updateDisplayNode() {
        final EntityPicker entityPicker = (EntityPicker) getSkinnable();
        AbstractDBEntity value = entityPicker.getValue();
        if (value != null)
            displayNode.setText(value.toString());
        else
            displayNode.setText("");
    }

    @Override
    public Node getDisplayNode() {
        if (displayNode == null) {
            // displayNode et textField contiennent le même objet: la variable displayNode ne sert que pour passer dans ce test
            displayNode = getEditableInputNode();
            updateDisplayNode();
        }
        displayNode.setEditable(entityPicker.isEditable());

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
