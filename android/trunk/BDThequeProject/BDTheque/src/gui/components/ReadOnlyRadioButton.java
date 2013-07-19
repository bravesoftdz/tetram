package org.tetram.bdtheque.gui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.RadioButton;

@SuppressWarnings("UnusedDeclaration")
public class ReadOnlyRadioButton extends RadioButton {

    public ReadOnlyRadioButton(Context context) {
        super(context);
    }

    public ReadOnlyRadioButton(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public ReadOnlyRadioButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    public void toggle() {
    }
}
