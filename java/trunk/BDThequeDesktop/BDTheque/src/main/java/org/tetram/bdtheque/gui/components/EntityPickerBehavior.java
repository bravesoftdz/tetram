/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPickerBehavior.java
 * Last modified by Tetram, on 2014-09-03T15:10:32CEST
 */

package org.tetram.bdtheque.gui.components;

import com.sun.javafx.scene.control.behavior.ComboBoxBaseBehavior;
import javafx.scene.control.ComboBoxBase;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;

/**
 * Created by Tetram on 03/09/2014.
 */
public class EntityPickerBehavior extends ComboBoxBaseBehavior<AbstractDBEntity> {
    public EntityPickerBehavior(ComboBoxBase<AbstractDBEntity> entityPicker) {
        super(entityPicker, null);
    }
}
