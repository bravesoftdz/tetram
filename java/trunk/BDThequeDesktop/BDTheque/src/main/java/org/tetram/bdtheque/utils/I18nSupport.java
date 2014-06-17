package org.tetram.bdtheque.utils;

import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.PropertyKey;

import java.text.MessageFormat;
import java.util.ResourceBundle;

/**
 * Created by Thierry on 09/06/2014.
 */
public class I18nSupport {

    @NonNls
    private final static ResourceBundle resourceBundle = ResourceBundle.getBundle("org.tetram.bdtheque.lang.bd");

    public static String message(@PropertyKey(resourceBundle = "org.tetram.bdtheque.lang.bd") String key, Object... params) {
        String value = resourceBundle.getString(key);
        if (params.length > 0)
            return MessageFormat.format(value, params);
        return value;
    }
}
