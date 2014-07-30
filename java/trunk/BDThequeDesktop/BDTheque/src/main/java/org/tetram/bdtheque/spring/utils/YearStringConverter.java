/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * YearStringConverter.java
 * Last modified by Tetram, on 2014-07-30T16:41:15CEST
 */

package org.tetram.bdtheque.spring.utils;

import javafx.util.StringConverter;
import org.tetram.bdtheque.utils.I18nSupport;

import java.time.Year;
import java.time.format.DateTimeFormatter;

/**
 * Created by Tetram on 30/07/2014.
 */
public class YearStringConverter extends StringConverter<Year> {

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern(I18nSupport.message("format.year"));

    @Override
    public String toString(Year value) {
        if (value == null) return "";
        return value.format(formatter);
    }

    @Override
    public Year fromString(String value) {
        if (value == null) return null;
        value = value.trim();
        if (value.isEmpty()) return null;

        return Year.parse(value, formatter);
    }
}
