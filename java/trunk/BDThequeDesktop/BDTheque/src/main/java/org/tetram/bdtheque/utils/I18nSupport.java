package org.tetram.bdtheque.utils;

import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.PropertyKey;

import java.text.MessageFormat;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * Created by Thierry on 09/06/2014.
 */
public class I18nSupport {

    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_LANG_BD = "org.tetram.bdtheque.lang.bd";
    private static ResourceBundle currentResourceBundle = getLocaleBundle(Locale.getDefault());
    private static Map<Locale, ResourceBundle> resources = null;

    private static String message(ResourceBundle resourceBundle, @PropertyKey(resourceBundle = ORG_TETRAM_BDTHEQUE_LANG_BD) String key, Object... params) {
        String value = resourceBundle.getString(key);
        if (params.length > 0)
            return MessageFormat.format(value, params);
        return value;
    }

    public static String message(Locale locale, @PropertyKey(resourceBundle = ORG_TETRAM_BDTHEQUE_LANG_BD) String key, Object... params) {
        return message(getLocaleBundle(locale), key, params);
    }

    public static String message(@PropertyKey(resourceBundle = ORG_TETRAM_BDTHEQUE_LANG_BD) String key, Object... params) {
        return message(currentResourceBundle, key, params);
    }

    private static ResourceBundle getLocaleBundle(Locale locale) {
        if (resources == null) resources = new HashMap<>();
        ResourceBundle resourceBundle = resources.get(locale);
        if (resourceBundle == null) {
            resourceBundle = ResourceBundle.getBundle(ORG_TETRAM_BDTHEQUE_LANG_BD, locale);
            resources.put(locale, resourceBundle);
        }
        return resourceBundle;
    }

    public static ResourceBundle getCurrentBundle() {
        return currentResourceBundle;
    }

    public static void setLocale(Locale locale) {
        currentResourceBundle = getLocaleBundle(locale);
    }

}
