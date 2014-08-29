/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPickerSkin.java
 * Last modified by Tetram, on 2014-08-29T12:20:44CEST
 */

package org.tetram.bdtheque.gui.components;

import com.sun.javafx.scene.control.skin.ComboBoxListViewSkin;
import javafx.beans.binding.Bindings;
import javafx.css.PseudoClass;
import javafx.scene.Node;
import javafx.scene.control.TextField;
import javafx.scene.layout.Region;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;
import org.tetram.bdtheque.utils.ClassLink;
import org.tetram.bdtheque.utils.ClassLinks;

/**
 * Created by Thierry on 10/08/2014.
 */
@ClassLinks({
        @ClassLink(com.sun.javafx.scene.control.skin.ColorPickerSkin.class),
        @ClassLink(com.sun.javafx.scene.control.skin.DatePickerSkin.class)
})
@SuppressWarnings("HardCodedStringLiteral")
public class EntityPickerSkin extends EntityPickerPopupControl<AbstractDBEntity> {

    private static final PseudoClass CONTAINS_FOCUS_PSEUDOCLASS_STATE = PseudoClass.getPseudoClass("contains-focus");

    private final EntityPicker entityPicker;
    private TextField textField;
    private Region displayRegion;
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
        return getEntityPickerContent();
    }

    private EntityPickerContent getEntityPickerContent() {
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
        popupContent.setContentMinWidth(entityPicker.getEntityPickerSkin().getDisplayRegion().getWidth());
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
        //getPopup().isShowing()
        textField.focusTraversableProperty().bind(Bindings.and(entityPicker.focusTraversableProperty(), getPopup().showingProperty()));
        textField.promptTextProperty().bind(entityPicker.promptTextProperty());
        textField.editableProperty().bind(entityPicker.editableProperty());

        textField.focusedProperty().addListener((ov, t, hasFocus) -> {
            entityPicker.getProperties().put("FOCUSED", hasFocus);
            if (!hasFocus) {
                pseudoClassStateChanged(CONTAINS_FOCUS_PSEUDOCLASS_STATE, false);
            } else {
                pseudoClassStateChanged(CONTAINS_FOCUS_PSEUDOCLASS_STATE, true);
            }
        });

        getTreeViewController().registerSearchableField(textField, false);
        textField.setOnKeyTyped(event -> {
            if (!event.getCharacter().isEmpty()) show();
        });

        return textField;
    }

    private void updateDisplayNode() {
        final EntityPicker entityPicker = (EntityPicker) getSkinnable();
        AbstractDBEntity value = entityPicker.getValue();
        if (value != null)
            textField.setText(value.toString());
        else
            textField.setText("");
    }

    @Override
    public Node getDisplayNode() {
        return getDisplayRegion();
    }

    public void syncWithAutoUpdate() {
        if (!getPopup().isShowing() && getSkinnable().isShowing()) {
            // Popup was dismissed. Maybe user clicked outside or typed ESCAPE.
            // Make sure EntityPicker button is in sync.
            getSkinnable().hide();
        }
    }

    public TreeViewController getTreeViewController() {
        return getEntityPickerContent().getTreeviewController();
    }

    public Region getDisplayRegion() {
        if (displayRegion == null) {
            // TODO: à terme, displayRegion devra contenir StackPane + textField + Boutons
            displayRegion = getEditableInputNode();
            updateDisplayNode();
        }

        return displayRegion;
    }
}
