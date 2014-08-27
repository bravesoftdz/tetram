/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityPickerBehavior.java
 * Last modified by Tetram, on 2014-08-27T15:15:45CEST
 */

package org.tetram.bdtheque.gui.components;

import com.sun.javafx.scene.control.behavior.ComboBoxBaseBehavior;
import com.sun.javafx.scene.control.behavior.KeyBinding;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.utils.ClassLink;
import org.tetram.bdtheque.utils.ClassLinks;

import java.util.ArrayList;
import java.util.List;

import static javafx.scene.input.KeyCode.*;
import static javafx.scene.input.KeyEvent.KEY_PRESSED;

/**
 * Created by Thierry on 10/08/2014.
 */
@ClassLinks({
        @ClassLink(com.sun.javafx.scene.control.behavior.ColorPickerBehavior.class),
        @ClassLink(com.sun.javafx.scene.control.behavior.DatePickerBehavior.class)
})
public class EntityPickerBehavior extends ComboBoxBaseBehavior<AbstractDBEntity> {
    @NonNls
    protected static final String OPEN_ACTION = "Open";
    @NonNls
    protected static final String CLOSE_ACTION = "Close";
    protected static final List<KeyBinding> ENTITY_PICKER_BINDINGS = new ArrayList<KeyBinding>();
    static {
//        ENTITY_PICKER_BINDINGS.addAll(COMBO_BOX_BASE_BINDINGS);
        ENTITY_PICKER_BINDINGS.add(new KeyBinding(ESCAPE, KEY_PRESSED, CLOSE_ACTION));
        ENTITY_PICKER_BINDINGS.add(new KeyBinding(SPACE, KEY_PRESSED, OPEN_ACTION));
        ENTITY_PICKER_BINDINGS.add(new KeyBinding(ENTER, KEY_PRESSED, OPEN_ACTION));

    }
    public EntityPickerBehavior(EntityPicker entityPicker) {
        super(entityPicker, ENTITY_PICKER_BINDINGS);
    }

    @Override protected void callAction(String name) {
        switch (name) {
            case OPEN_ACTION:
                show();
                break;
            case CLOSE_ACTION:
                hide();
                break;
            default:
                super.callAction(name);
                break;
        }
    }

    @Override public void onAutoHide() {
        // when we click on some non  interactive part of the
        // Color Palette - we do not want to hide.
        EntityPicker entityPicker = (EntityPicker)getControl();
        EntityPickerSkin epSkin = (EntityPickerSkin)entityPicker.getSkin();
        epSkin.syncWithAutoUpdate();
        // if the ColorPicker is no longer showing, then invoke the super method
        // to keep its show/hide state in sync.
        if (!entityPicker.isShowing()) super.onAutoHide();
    }

}
