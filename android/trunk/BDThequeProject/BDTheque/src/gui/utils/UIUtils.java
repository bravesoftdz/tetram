package org.tetram.bdtheque.gui.utils;

import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.view.View;
import android.widget.CheckBox;
import android.widget.TextView;

import org.jetbrains.annotations.Nullable;

import java.lang.reflect.Method;
import java.net.URL;

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

    @Nullable
    public static <T> View setUIElementURL(View parent, int resId, T value, URL url, int resRowId) {
        if (url != null) {
            String text = String.format("<a href=\"%s\">%s</a>", url, value);
            View textView = setUIElement(parent, resId, Html.fromHtml(text), resRowId);
            if (textView instanceof TextView)
                ((TextView) textView).setMovementMethod(LinkMovementMethod.getInstance());
            return textView;
        } else
            return setUIElement(parent, resId, value, resRowId);
    }

    @Nullable
    public static <T> View setUIElement(View parent, int resId, T value, int resRowId) {
        if ((resRowId != -1) && isEmpty(value)) {
            parent.findViewById(resRowId).setVisibility(View.GONE);
            return null;
        }

        View v = parent.findViewById(resId);
        if (v != null) setUIValue(v, value);
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
