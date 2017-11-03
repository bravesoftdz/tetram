/*
 * Copyright (c) 2015, tetram.org. All Rights Reserved.
 * EntityPickerBehavior.java
 * Last modified by Thierry, on 2014-10-31T18:16:41CET
 */

package org.tetram.bdtheque.gui.components;

import com.sun.javafx.scene.control.behavior.ComboBoxBaseBehavior;
import com.sun.javafx.scene.control.behavior.KeyBinding;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;

import java.util.ArrayList;
import java.util.List;

import static javafx.scene.input.KeyCode.*;
import static javafx.scene.input.KeyEvent.KEY_PRESSED;

/**
 * Created by Tetram on 03/09/2014.
 */
public class EntityPickerBehavior<E extends AbstractDBEntity> extends ComboBoxBaseBehavior<E> {

    @NonNls
    protected static final String OPEN_ACTION = "Open";
    @NonNls
    protected static final String CLOSE_ACTION = "Close";

    protected static final List<KeyBinding> ENTITY_PICKER_BINDINGS = new ArrayList<>();

    static {
//        ENTITY_PICKER_BINDINGS.addAll(COMBO_BOX_BASE_BINDINGS);
        ENTITY_PICKER_BINDINGS.add(new KeyBinding(ESCAPE, KEY_PRESSED, CLOSE_ACTION));
        ENTITY_PICKER_BINDINGS.add(new KeyBinding(SPACE, KEY_PRESSED, OPEN_ACTION));
        ENTITY_PICKER_BINDINGS.add(new KeyBinding(ENTER, KEY_PRESSED, OPEN_ACTION));

    }

    public EntityPickerBehavior(final EntityPicker<E> entityPicker) {
        super(entityPicker, ENTITY_PICKER_BINDINGS);
    }

    @Override
    protected void callAction(String name) {
        if (OPEN_ACTION.equals(name)) {
            show();
        } else if (CLOSE_ACTION.equals(name)) {
            hide();
        } else super.callAction(name);
    }

    /**
     * ***********************************************************************
     * *
     * Mouse Events                                                           *
     * *
     * ***********************************************************************
     */

    @Override
    public void onAutoHide() {
        EntityPicker entityPicker = (EntityPicker) getControl();
        EntityPickerSkin epSkin = (EntityPickerSkin) entityPicker.getSkin();
        epSkin.syncWithAutoUpdate();
        if (!entityPicker.isShowing()) super.onAutoHide();
    }

}
