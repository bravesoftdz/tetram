/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * LocalDateStringConverter.java
 * Last modified by Tetram, on 2014-07-30T16:41:37CEST
 */

package org.tetram.bdtheque.spring.utils;

import javafx.util.StringConverter;
import org.tetram.bdtheque.utils.I18nSupport;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Created by Tetram on 30/07/2014.
 */
public class LocalDateStringConverter extends StringConverter<LocalDate> {

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern(I18nSupport.message("format/date"));

    @Override
    public String toString(LocalDate value) {
        if (value == null) return "";
        return value.format(formatter);
    }

    @Override
    public LocalDate fromString(String value) {
        if (value == null) return null;
        value = value.trim();
        if (value.isEmpty()) return null;

        return LocalDate.parse(value, formatter);
    }
}
