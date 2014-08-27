/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPicker.java
 * Last modified by Tetram, on 2014-08-27T16:23:55CEST
 */

package org.tetram.bdtheque.gui.components;

import com.sun.javafx.scene.control.skin.ComboBoxListViewSkin;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.beans.property.ReadOnlyObjectWrapper;
import javafx.beans.property.SimpleObjectProperty;
import javafx.scene.control.ComboBoxBase;
import javafx.scene.control.Skin;
import javafx.scene.control.TextField;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewMode;
import org.tetram.bdtheque.utils.ClassLink;
import org.tetram.bdtheque.utils.ClassLinks;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 10/08/2014.
 */
@ClassLinks({
        @ClassLink(javafx.scene.control.ColorPicker.class),
        @ClassLink(javafx.scene.control.DatePicker.class)
})
public class EntityPicker extends ComboBoxBase<AbstractDBEntity> {
    @NonNls
    private static final String DEFAULT_STYLE_CLASS = "entity-picker";
    private EntityPickerSkin entityPickerSkin;
    private ObjectProperty<UUID> parentValue = new SimpleObjectProperty<>(this, "parentValue", null);
    private ReadOnlyObjectWrapper<TextField> editor;

    public EntityPicker() {
        this(null);
    }

    @SuppressWarnings("HardCodedStringLiteral")
    public EntityPicker(AbstractDBEntity entity) {
        setValue(entity);
        getStyleClass().add(DEFAULT_STYLE_CLASS);
        setEditable(true);

        parentValue.addListener(o -> {
            String filtre = null;
            if (getParentValue() != null) {
                switch (getMode()) {
                    case COLLECTIONS:
                        filtre = String.format("id_editeur = '%s'", StringUtils.UUIDToGUIDString(getParentValue()));
                        break;
                    case UNIVERS:
                        filtre = String.format("branche_univers not containing '|%s|'", StringUtils.UUIDToGUIDString(getParentValue()));
                        break;
                }
            }
            getTreeViewController().setFiltre(filtre);
        });
    }

    @Override
    protected Skin<?> createDefaultSkin() {
        return getEntityPickerSkin();
    }

    public EntityPickerSkin getEntityPickerSkin() {
        if (entityPickerSkin == null) entityPickerSkin = new EntityPickerSkin(this);
        return entityPickerSkin;
    }

    public TreeViewMode getMode() {
        return modeProperty().get();
    }

    public void setMode(TreeViewMode mode) {
        modeProperty().set(mode);
    }

    public ObjectProperty<TreeViewMode> modeProperty() {
        return getTreeViewController().modeProperty();
    }

    private TreeViewController getTreeViewController() {
        return getEntityPickerSkin().getTreeViewController();
    }

    public ObjectProperty<UUID> parentValueProperty() {
        return parentValue;
    }

    public UUID getParentValue() {
        return parentValue.get();
    }

    public void setParentValue(UUID parentValue) {
        this.parentValue.set(parentValue);
    }

    public final TextField getEditor() {
        return editorProperty().get();
    }
    public final ReadOnlyObjectProperty<TextField> editorProperty() {
        if (editor == null) {
            editor = new ReadOnlyObjectWrapper<>(this, "editor", new ComboBoxListViewSkin.FakeFocusTextField());
        }
        return editor.getReadOnlyProperty();
    }

    @Override
    protected double computeMinWidth(double height) {
        return super.computeMinWidth(height);
    }

}
