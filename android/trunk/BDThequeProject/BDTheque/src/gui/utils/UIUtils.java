package org.tetram.bdtheque.gui.utils;

import android.view.View;
import android.widget.TextView;

public abstract class UIUtils {
    private UIUtils() {
        super();
    }

    public static <T> View setUIElement(View parent, int resId, T value) {
        View v = parent.findViewById(resId);
        if (v != null) {
            setUIValue(v, value);
        }
        return v;
    }

    private static <T> void setUIValue(View v, T value) {
        if (v instanceof TextView)
            ((TextView) v).setText(String.valueOf(value));
    }
}
