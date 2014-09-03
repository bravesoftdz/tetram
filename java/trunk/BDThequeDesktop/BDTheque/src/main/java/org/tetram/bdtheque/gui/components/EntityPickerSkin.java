/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPickerSkin.java
 * Last modified by Tetram, on 2014-09-03T16:44:23CEST
 */

package org.tetram.bdtheque.gui.components;

import javafx.beans.property.StringProperty;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.scene.layout.Background;
import javafx.scene.layout.StackPane;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;

/**
 * Created by Tetram on 03/09/2014.
 */
public class EntityPickerSkin extends EntityPickerPopupControl<AbstractDBEntity> {

    private final EntityPicker entityPicker;
    private StackPane displayNode;
    private TextField textField;
    private EntityPickerContent popupContent;

    public EntityPickerSkin(final EntityPicker entityPicker) {
        super(entityPicker, new EntityPickerBehavior(entityPicker));
        this.entityPicker = entityPicker;

        registerChangeListener(entityPicker.valueProperty(), "VALUE");
    }

    @Override
    public Node getDisplayNode() {
        if (displayNode == null) {
            StackPane rootStack = new StackPane();

            textField = new TextField();
            StackPane.setAlignment(textField, Pos.CENTER);
            textField.promptTextProperty().bind(entityPicker.promptTextProperty());
            textField.editableProperty().bind(entityPicker.editableProperty());

            entityPicker.focusedProperty().addListener((ov, t, hasFocus) -> {
                textField.requestFocus();
            });

            @NonNls Button btnReset = new Button();
            btnReset.setMinWidth(10);
            btnReset.minHeightProperty().bind(textField.heightProperty());
            btnReset.visibleProperty().bind(entityPicker.valueProperty().isNotNull());
            btnReset.setFocusTraversable(false);
            btnReset.setBackground(Background.EMPTY);
            btnReset.setText("X");
            btnReset.setOnAction(event -> entityPicker.setValue(null));
            StackPane.setAlignment(btnReset, Pos.CENTER_RIGHT);

            rootStack.getChildren().addAll(textField, btnReset);

            displayNode = rootStack;
        }
        return displayNode;
    }

    @Override
    protected Node getPopupContent() {
        if (popupContent == null) {
            popupContent = new EntityPickerContent(entityPicker);
            popupContent.minWidthProperty().bind(textField.widthProperty());
        }
        return popupContent.getView();
    }

    @Override
    protected void handleControlPropertyChanged(@NonNls String p) {
        super.handleControlPropertyChanged(p);

        if ("VALUE".equals(p))
            updateDisplayNode();
    }

    private void updateDisplayNode() {
        AbstractDBEntity value = entityPicker.getValue();
        getEditor().setText(value == null ? null : value.getLabel());
    }

    public TextField getEditor() {
        getDisplayNode();
        return textField;
    }

    public String getFiltre() {
        getPopupContent();
        return popupContent.getFiltre();
    }

    public void setFiltre(String filtre) {
        getPopupContent();
        popupContent.setFiltre(filtre);
    }

    public StringProperty filtreProperty() {
        getPopupContent();
        return popupContent.filtreProperty();
    }
}
