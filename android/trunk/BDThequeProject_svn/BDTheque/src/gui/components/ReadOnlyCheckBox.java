package org.tetram.bdtheque.gui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.CheckBox;

@SuppressWarnings("UnusedDeclaration")
public class ReadOnlyCheckBox extends CheckBox {

    public ReadOnlyCheckBox(Context context) {
        super(context);
    }

    public ReadOnlyCheckBox(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public ReadOnlyCheckBox(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    public void toggle() {
    }

}
