package org.tetram.bdtheque.gui.utils;

import android.view.View;
import android.widget.CheckBox;
import android.widget.TextView;

import java.lang.reflect.Method;

public abstract class UIUtils {
    private UIUtils() {
        super();
    }

    public static <T> View setUIElement(View parent, int resId, T value) {
        return setUIElement(parent, resId, value, -1);
    }

    private static boolean isEmpty(Object o) {
        if (o == null) return true;
        final Class<?> aClass = o.getClass();
        if (aClass.isPrimitive())
            return false;
        else {
            try {
                Method method = aClass.getMethod("isEmpty", (Class[]) null);
                return (boolean) method.invoke(o);
            } catch (Exception e) {
                return false;
            }
        }
    }

    public static <T> View setUIElement(View parent, int resId, T value, int resRowId) {
        View v = parent.findViewById(resId);
        if ((resRowId != -1) && isEmpty(value))
            parent.findViewById(resRowId).setVisibility(View.GONE);
        else if (v != null) {
            setUIValue(v, value);
        }
        return v;
    }

    private static <T> void setUIValue(View v, T value) {
        if (value == null) return;
        if (v instanceof CheckBox)
            ((CheckBox) v).setChecked((Boolean) value);
        else if (v instanceof TextView)
            ((TextView) v).setText(String.valueOf(value));

    }
}
