/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * I18nSupport.java
 * Last modified by Tetram, on 2014-08-26T10:54:23CEST
 */
package org.tetram.bdtheque.utils;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.PropertyKey;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.MessageFormat;
import java.text.NumberFormat;
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
    private static NumberFormat currencyFormatter = null;
    private static StringProperty currencySymbol = null;

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

    public static Locale getLocale() {
        return currentResourceBundle.getLocale();
    }

    public static void setLocale(Locale locale) {
        currentResourceBundle = getLocaleBundle(locale);
    }

    public static NumberFormat getCurrencyFormatter() {
        if (currencyFormatter == null) {
            currencyFormatter = NumberFormat.getCurrencyInstance(getLocale());
            useCurrencySymbol();
        }
        return currencyFormatter;
    }

    private static void useCurrencySymbol() {
        if (currencyFormatter != null) {
            final DecimalFormatSymbols symbols = ((DecimalFormat) currencyFormatter).getDecimalFormatSymbols();
            symbols.setCurrencySymbol(getCurrencySymbol());
            ((DecimalFormat) currencyFormatter).setDecimalFormatSymbols(symbols);
        }
    }

    public static StringProperty currencySymbolProperty() {
        if (currencySymbol == null) {
            currencySymbol = new SimpleStringProperty(null, "currencySymbol", "€") {
                @Override
                protected void invalidated() {
                    super.invalidated();
                    useCurrencySymbol();
                }
            };
        }
        return currencySymbol;
    }

    public static String getCurrencySymbol() {
        return currencySymbolProperty().get();
    }

    public static void setCurrencySymbol(String currencySymbol) {
        currencySymbolProperty().set(currencySymbol);
    }
}
