/*
 * Copyright (c) 2015, tetram.org. All Rights Reserved.
 * EntityPickerSkin.java
 * Last modified by Thierry, on 2014-10-31T18:17:24CET
 */

package org.tetram.bdtheque.gui.components;

import com.sun.javafx.scene.control.skin.ComboBoxPopupControl;
import javafx.beans.property.StringProperty;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.Label;
import javafx.scene.effect.ColorAdjust;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Background;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.utils.ClassLink;
import org.tetram.bdtheque.utils.ClassLinks;

/**
 * Created by Tetram on 03/09/2014.
 */
@ClassLinks({
        @ClassLink(com.sun.javafx.scene.control.skin.ColorPickerSkin.class),
        @ClassLink(com.sun.javafx.scene.control.skin.DatePickerSkin.class)
})
public class EntityPickerSkin<E extends AbstractDBEntity> extends ComboBoxPopupControl<E> {

    private final Label displayNode = new Label();

    private EntityPickerContent popupContent;

    @SuppressWarnings("HardCodedStringLiteral")
    public EntityPickerSkin(final EntityPicker<E> entityPicker) {
        super(entityPicker, new EntityPickerBehavior<>(entityPicker));

        registerChangeListener(entityPicker.valueProperty(), "VALUE");

        displayNode.getStyleClass().add("entity-picker-label");
        displayNode.setBackground(Background.EMPTY);

        Button btReset = new Button();
        btReset.getStyleClass().add("entity-picker-button-reset");
        btReset.setMinWidth(10);
        btReset.minHeightProperty().bind(displayNode.heightProperty());
        btReset.visibleProperty().bind(entityPicker.valueProperty().isNotNull());
        btReset.setFocusTraversable(false);
        btReset.setBackground(Background.EMPTY);
        btReset.setOnAction(event -> entityPicker.setValue(null));

        btReset.setText("X");

        btReset.setContentDisplay(ContentDisplay.GRAPHIC_ONLY);
        btReset.setGraphic(new ImageView("org/tetram/bdtheque/gui/components/entityPicker-reset.png"));
        ColorAdjust colorAdjust = new ColorAdjust(0, -0.75, 0, 0);
        btReset.getGraphic().setEffect(colorAdjust);
        btReset.setOnMouseEntered(event -> btReset.getGraphic().setEffect(null));
        btReset.setOnMouseExited(event -> btReset.getGraphic().setEffect(colorAdjust));

        displayNode.setContentDisplay(ContentDisplay.LEFT);
        displayNode.setGraphic(btReset);

        updateDisplayNode();

    }

    @Override
    protected Node getPopupContent() {
        if (popupContent == null) {
            popupContent = new EntityPickerContent((EntityPicker) getSkinnable());
            popupContent.setPopupControl(getPopup());
            popupContent.minWidthProperty().bind(displayNode.widthProperty());
        }
        return popupContent.getView();
    }

    @Override
    protected void focusLost() {
        // do nothing
        syncWithAutoUpdate();
    }

    @Override
    protected void handleControlPropertyChanged(@NonNls String p) {
        super.handleControlPropertyChanged(p);

        if ("SHOWING".equals(p)) {
            if (getSkinnable().isShowing()) {
                final EntityPicker<E> entityPicker = (EntityPicker<E>) getSkinnable();
                popupContent.updateSelection(entityPicker.getValue());
                popupContent.clearFocus();
            }
        } else if ("VALUE".equals(p)) {
            updateDisplayNode();
        }
    }

    @Override
    public Node getDisplayNode() {
        return displayNode;
    }

    private void updateDisplayNode() {
        final EntityPicker<E> entityPicker = (EntityPicker<E>) getSkinnable();
        AbstractDBEntity value = entityPicker.getValue();
        displayNode.setText(value == null ? null : value.getLabel());
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

    public void syncWithAutoUpdate() {
        if (!getPopup().isShowing() && getSkinnable().isShowing()) {
            // Popup was dismissed. Maybe user clicked outside or typed ESCAPE.
            // Make sure EntityPicker button is in sync.
            getSkinnable().hide();
        }
    }
}
