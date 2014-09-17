/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPicker.java
 * Last modified by Tetram, on 2014-09-05T10:50:18CEST
 */

package org.tetram.bdtheque.gui.components;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.scene.control.ComboBoxBase;
import javafx.scene.control.Skin;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewMode;
import org.tetram.bdtheque.utils.ClassLink;
import org.tetram.bdtheque.utils.ClassLinks;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Tetram on 03/09/2014.
 */
@ClassLinks({
        @ClassLink(javafx.scene.control.ColorPicker.class),
        @ClassLink(javafx.scene.control.DatePicker.class)
})
public class EntityPicker extends ComboBoxBase<AbstractDBEntity> {
    @NonNls
    private static final String DEFAULT_STYLE_CLASS = "entity-picker";

    private final ObjectProperty<UUID> parentValue = new SimpleObjectProperty<>(this, "parentValue", null);
    private final ObjectProperty<TreeViewMode> mode = new SimpleObjectProperty<>(this, "mode", TreeViewMode.NONE);
    private final StringProperty filtre = new SimpleStringProperty(this, "filtre", null);

    private EntityPickerSkin entityPickerSkin;

    @SuppressWarnings("HardCodedStringLiteral")
    public EntityPicker() {
        setValue(null);
        getStyleClass().add(DEFAULT_STYLE_CLASS);

        parentValue.addListener((o, ov, nv) -> {
            String newFiltre = null;
            if (nv != null) {
                switch (getMode()) {
                    case COLLECTIONS:
                        newFiltre = String.format("id_editeur = '%s'", StringUtils.UUIDToGUIDString(getParentValue()));
                        break;
                    case UNIVERS:
                        newFiltre = String.format("branche_univers not containing '|%s|'", StringUtils.UUIDToGUIDString(getParentValue()));
                        break;
                }
            }
            setFiltre(newFiltre);
        });
    }

    @Override
    protected Skin<?> createDefaultSkin() {
        if (entityPickerSkin == null) entityPickerSkin = new EntityPickerSkin(this);
        return entityPickerSkin;
    }

    @Override
    protected double computeMinWidth(double height) {
        // 29/08/2014: les ComboBox (et toutes les classes qui vont avec) sont pensés pour avoir une taille fixe
        return 20.0;
        // et pourtant, on peut quand même faire un bind de leur prefWidth pour faire un redimensionnement dynamique
    }

    public ObjectProperty<UUID> parentValueProperty() {
        return parentValue;
    }

    public UUID getParentValue() {
        return parentValueProperty().get();
    }

    public void setParentValue(UUID parentValue) {
        parentValueProperty().set(parentValue);
    }

    public ObjectProperty<TreeViewMode> modeProperty() {
        return mode;
    }

    public TreeViewMode getMode() {
        return modeProperty().get();
    }

    public void setMode(TreeViewMode mode) {
        modeProperty().set(mode);
    }

    public StringProperty filtreProperty() {
        return filtre;
    }

    public String getFiltre() {
        return filtreProperty().get();
    }

    public void setFiltre(String filtre) {
        filtreProperty().set(filtre);
    }

}
